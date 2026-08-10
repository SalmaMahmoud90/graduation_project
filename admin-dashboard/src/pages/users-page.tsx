import { useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { Inbox, Search } from 'lucide-react'
import { toast } from 'sonner'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table'
import { Skeleton } from '@/components/ui/skeleton'
import { ListEmptyState } from '@/components/empty-state'
import { SortableTableHead } from '@/components/table/sortable-table-head'
import { TablePagination } from '@/components/table/table-pagination'
import { useBanUser, useUsersPage } from '@/hooks/use-admin-queries'
import type { SortDir } from '@/lib/client-table'
import { sortRows } from '@/lib/client-table'
import { formatDateTime } from '@/lib/format'
import { useTableFiltersStore } from '@/stores/table-filters-store'
import type { User, UserRole, UserStatus } from '@/types/domain'
import { useI18n } from '@/contexts/i18n'

const USER_SORT_KEYS = ['fullName', 'role', 'status', 'createdAt'] as const
type UserSortKey = (typeof USER_SORT_KEYS)[number]

function roleLabel(role: UserRole, t: (key: string) => string) {
  if (role === 'driver') return t('users.role.driver')
  if (role === 'passenger') return t('users.role.passenger')
  return t('users.role.admin')
}

function statusBadge(status: UserStatus, t: (key: string) => string) {
  if (status === 'banned')
    return <Badge variant="destructive">{t('users.status.banned')}</Badge>
  return (
    <Badge variant="secondary" className="font-normal">
      {t('users.status.active')}
    </Badge>
  )
}

function userSortValue(u: User, key: UserSortKey): string {
  switch (key) {
    case 'fullName':
      return u.fullName
    case 'role':
      return u.role
    case 'status':
      return u.status
    case 'createdAt':
      return u.createdAt
    default:
      return ''
  }
}

export function UsersPage() {
  const { locale, t } = useI18n()
  const query = useTableFiltersStore((s) => s.usersQuery)
  const setQuery = useTableFiltersStore((s) => s.setUsersQuery)
  const [page, setPage] = useState(1)
  const [pageSize, setPageSize] = useState(10)
  const { data, isLoading, isError } = useUsersPage(page, pageSize)
  const ban = useBanUser()

  const [sortKey, setSortKey] = useState<UserSortKey>('createdAt')
  const [sortDir, setSortDir] = useState<SortDir>('desc')

  const filtered = useMemo(() => {
    if (!data) return []
    const q = query.trim().toLowerCase()
    if (!q) return data.results
    return data.results.filter(
      (u) =>
        u.fullName.toLowerCase().includes(q) ||
        u.email.toLowerCase().includes(q) ||
        u.id.toLowerCase().includes(q),
    )
  }, [data, query])

  const sorted = useMemo(
    () =>
      sortRows(filtered, (u) => userSortValue(u, sortKey), sortDir),
    [filtered, sortKey, sortDir],
  )

  const hasNext = Boolean(data?.next)
  const total = data?.count ?? (hasNext ? page * pageSize : (page - 1) * pageSize + sorted.length)
  const totalPages = data?.count
    ? Math.max(1, Math.ceil(data.count / pageSize))
    : Math.max(1, page + (hasNext ? 1 : 0))
  const pageRows = sorted

  function handleSort(key: string) {
    if (!USER_SORT_KEYS.includes(key as UserSortKey)) return
    const k = key as UserSortKey
    if (k === sortKey) setSortDir((d) => (d === 'asc' ? 'desc' : 'asc'))
    else {
      setSortKey(k)
      setSortDir('asc')
    }
    setPage(1)
  }

  if (isError) {
    return (
      <p className="text-destructive text-sm">{t('users.error')}</p>
    )
  }

  const showFilterEmpty =
    !isLoading && data && filtered.length === 0 && query.trim() !== ''
  const showNoData = !isLoading && data && data.results.length === 0

  return (
    <div className="space-y-4">
      <div className="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
        <div>
          <h2 className="text-2xl font-semibold tracking-tight">
            {t('users.title')}
          </h2>
          <p className="text-muted-foreground mt-1 text-sm max-w-xl">
            {t('users.description')}
          </p>
        </div>
        <div className="w-full sm:max-w-xs">
          <Input
            placeholder={t('users.searchPlaceholder')}
            value={query}
            onChange={(e) => {
              setQuery(e.target.value)
              setPage(1)
            }}
            aria-label={t('users.searchAria')}
          />
        </div>
      </div>

      <p className="text-muted-foreground text-xs md:hidden">
        {t('table.scrollHint')}
      </p>

      {showNoData ? (
        <ListEmptyState
          icon={Inbox}
          title={t('emptyState.users.noneTitle')}
          description={t('emptyState.users.noneDescription')}
        />
      ) : showFilterEmpty ? (
        <ListEmptyState
          icon={Search}
          title={t('emptyState.filteredTitle')}
          description={t('emptyState.filteredDescription')}
          actionLabel={t('emptyState.clearFilters')}
          onAction={() => setQuery('')}
        />
      ) : (
        <div className="flex flex-col overflow-hidden rounded-md border">
          <Table stickyHeader>
            <TableHeader>
              <TableRow>
                <SortableTableHead
                  label={t('users.table.user')}
                  sortKey="fullName"
                  activeKey={sortKey}
                  dir={sortDir}
                  onSort={handleSort}
                />
                <SortableTableHead
                  label={t('users.table.role')}
                  sortKey="role"
                  activeKey={sortKey}
                  dir={sortDir}
                  onSort={handleSort}
                />
                <SortableTableHead
                  label={t('users.table.status')}
                  sortKey="status"
                  activeKey={sortKey}
                  dir={sortDir}
                  onSort={handleSort}
                />
                <TableHead>{t('users.table.reports')}</TableHead>
                <SortableTableHead
                  label={t('users.table.joined')}
                  sortKey="createdAt"
                  activeKey={sortKey}
                  dir={sortDir}
                  onSort={handleSort}
                />
                <TableHead className="text-start">{t('users.table.actions')}</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {isLoading &&
                Array.from({ length: 5 }).map((_, i) => (
                  <TableRow key={i}>
                    <TableCell colSpan={6}>
                      <Skeleton className="h-10 w-full" />
                    </TableCell>
                  </TableRow>
                ))}
              {!isLoading &&
                pageRows.map((u) => (
                  <TableRow key={u.id}>
                    <TableCell>
                      <div className="flex flex-col">
                        <Link
                          to={`/users/${u.id}`}
                          className="font-medium underline-offset-4 hover:underline focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring rounded-sm w-fit text-start"
                        >
                          {u.fullName}
                        </Link>
                        <span className="text-muted-foreground text-xs">
                          {u.email}
                        </span>
                      </div>
                    </TableCell>
                    <TableCell>{roleLabel(u.role, t)}</TableCell>
                    <TableCell>{statusBadge(u.status, t)}</TableCell>
                    <TableCell>
                      {u.reportsCount > 0 ? (
                        <Link
                          to={`/reports?user=${u.id}`}
                          className="rounded-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
                        >
                          <Badge variant="destructive">{u.reportsCount}</Badge>
                        </Link>
                      ) : (
                        <span className="text-muted-foreground text-xs">—</span>
                      )}
                    </TableCell>
                    <TableCell className="text-muted-foreground text-sm">
                      {formatDateTime(u.createdAt, locale)}
                    </TableCell>
                    <TableCell className="text-right">
                      {u.role === 'admin' ? (
                        <span className="text-muted-foreground text-xs">—</span>
                      ) : (
                        <Button
                          size="sm"
                          variant={u.status === 'banned' ? 'outline' : 'destructive'}
                          disabled={ban.isPending}
                          onClick={() =>
                            ban.mutate(
                              { userId: u.id, banned: u.status !== 'banned' },
                              {
                                onSuccess: (_, variables) =>
                                  toast.success(
                                    variables.banned
                                      ? t('users.ban.success')
                                      : t('users.unban.success'),
                                  ),
                                onError: () =>
                                  toast.error(t('users.update.error')),
                              },
                            )
                          }
                        >
                          {u.status === 'banned'
                            ? t('users.action.unban')
                            : t('users.action.ban')}
                        </Button>
                      )}
                    </TableCell>
                  </TableRow>
                ))}
            </TableBody>
          </Table>
          {!isLoading && sorted.length > 0 ? (
            <TablePagination
              page={page}
              pageSize={pageSize}
              total={total}
              totalPages={totalPages}
              onPageChange={setPage}
              onPageSizeChange={(n) => {
                setPageSize(n)
                setPage(1)
              }}
            />
          ) : null}
        </div>
      )}
    </div>
  )
}
