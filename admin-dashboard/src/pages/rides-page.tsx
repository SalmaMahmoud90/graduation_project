import { useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { Inbox, Search } from 'lucide-react'
import { Badge } from '@/components/ui/badge'
import { Input } from '@/components/ui/input'
import {
  Table,
  TableBody,
  TableCell,
  TableHeader,
  TableRow,
} from '@/components/ui/table'
import { Skeleton } from '@/components/ui/skeleton'
import { ListEmptyState } from '@/components/empty-state'
import { SortableTableHead } from '@/components/table/sortable-table-head'
import { TablePagination } from '@/components/table/table-pagination'
import { useRidesPage } from '@/hooks/use-admin-queries'
import type { SortDir } from '@/lib/client-table'
import { sortRows } from '@/lib/client-table'
import { formatNumber, formatRideDeparture, formatRouteLabel } from '@/lib/format'
import { useTableFiltersStore } from '@/stores/table-filters-store'
import type { Ride, RideStatus } from '@/types/domain'
import { useI18n } from '@/contexts/i18n'

const RIDE_SORT_KEYS = [
  'route',
  'driver',
  'departure',
  'seats',
  'fare',
  'status',
] as const
type RideSortKey = (typeof RIDE_SORT_KEYS)[number]

function rideStatusBadge(status: RideStatus, t: (key: string) => string) {
  const map: Record<
    RideStatus,
    { label: string; variant: 'default' | 'secondary' | 'outline' | 'destructive' }
  > = {
    active: { label: t('rides.status.active'), variant: 'secondary' },
    scheduled: { label: t('rides.status.scheduled'), variant: 'secondary' },
    in_progress: { label: t('rides.status.in_progress'), variant: 'default' },
    completed: { label: t('rides.status.completed'), variant: 'outline' },
    cancelled: { label: t('rides.status.cancelled'), variant: 'destructive' },
  }
  const m = map[status]
  return <Badge variant={m.variant}>{m.label}</Badge>
}

function rideSortValue(r: Ride, key: RideSortKey): string | number {
  switch (key) {
    case 'route':
      return `${r.origin}\0${r.destination}`
    case 'driver':
      return r.driverName
    case 'departure':
      return r.departureAt
    case 'seats':
      return r.seatsTaken
    case 'fare':
      return r.fareShare
    case 'status':
      return r.status
    default:
      return ''
  }
}

export function RidesPage() {
  const { locale, t } = useI18n()
  const query = useTableFiltersStore((s) => s.ridesQuery)
  const setQuery = useTableFiltersStore((s) => s.setRidesQuery)
  const [page, setPage] = useState(1)
  const [pageSize, setPageSize] = useState(10)
  const { data, isLoading, isError } = useRidesPage(page, pageSize)

  const [sortKey, setSortKey] = useState<RideSortKey>('departure')
  const [sortDir, setSortDir] = useState<SortDir>('desc')

  const filtered = useMemo(() => {
    if (!data) return []
    const q = query.trim().toLowerCase()
    if (!q) return data.results
    return data.results.filter(
      (r) =>
        r.origin.toLowerCase().includes(q) ||
        r.destination.toLowerCase().includes(q) ||
        r.driverName.toLowerCase().includes(q) ||
        r.id.toLowerCase().includes(q),
    )
  }, [data, query])

  const sorted = useMemo(
    () =>
      sortRows(filtered, (r) => rideSortValue(r, sortKey), sortDir),
    [filtered, sortKey, sortDir],
  )

  const hasNext = Boolean(data?.next)
  const total = data?.count ?? (hasNext ? page * pageSize : (page - 1) * pageSize + sorted.length)
  const totalPages = data?.count
    ? Math.max(1, Math.ceil(data.count / pageSize))
    : Math.max(1, page + (hasNext ? 1 : 0))
  const pageRows = sorted

  function handleSort(key: string) {
    if (!RIDE_SORT_KEYS.includes(key as RideSortKey)) return
    const k = key as RideSortKey
    if (k === sortKey) setSortDir((d) => (d === 'asc' ? 'desc' : 'asc'))
    else {
      setSortKey(k)
      setSortDir('asc')
    }
    setPage(1)
  }

  if (isError) {
    return (
      <p className="text-destructive text-sm">{t('rides.error')}</p>
    )
  }

  const showFilterEmpty =
    !isLoading && data && filtered.length === 0 && query.trim() !== ''
  const showNoData = !isLoading && data && data.results.length === 0

  return (
    <div className="space-y-4">
      <div className="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
        <div>
          <h2 className="text-2xl font-semibold tracking-tight">{t('rides.title')}</h2>
          <p className="text-muted-foreground mt-1 text-sm max-w-xl">
            {t('rides.description')}
          </p>
        </div>
        <div className="w-full sm:max-w-xs">
          <Input
            placeholder={t('rides.searchPlaceholder')}
            value={query}
            onChange={(e) => {
              setQuery(e.target.value)
              setPage(1)
            }}
            aria-label={t('rides.searchAria')}
          />
        </div>
      </div>

      <p className="text-muted-foreground text-xs md:hidden">
        {t('table.scrollHint')}
      </p>

      {showNoData ? (
        <ListEmptyState
          icon={Inbox}
          title={t('emptyState.rides.noneTitle')}
          description={t('emptyState.rides.noneDescription')}
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
                  label={t('rides.table.route')}
                  sortKey="route"
                  activeKey={sortKey}
                  dir={sortDir}
                  onSort={handleSort}
                />
                <SortableTableHead
                  label={t('rides.table.driver')}
                  sortKey="driver"
                  activeKey={sortKey}
                  dir={sortDir}
                  onSort={handleSort}
                />
                <SortableTableHead
                  label={t('rides.table.departure')}
                  sortKey="departure"
                  activeKey={sortKey}
                  dir={sortDir}
                  onSort={handleSort}
                />
                <SortableTableHead
                  label={t('rides.table.seats')}
                  sortKey="seats"
                  activeKey={sortKey}
                  dir={sortDir}
                  onSort={handleSort}
                  className="text-start"
                />
                <SortableTableHead
                  label={t('rides.table.fare')}
                  sortKey="fare"
                  activeKey={sortKey}
                  dir={sortDir}
                  onSort={handleSort}
                  className="text-start"
                />
                <SortableTableHead
                  label={t('rides.table.status')}
                  sortKey="status"
                  activeKey={sortKey}
                  dir={sortDir}
                  onSort={handleSort}
                />
              </TableRow>
            </TableHeader>
            <TableBody>
              {isLoading &&
                Array.from({ length: 4 }).map((_, i) => (
                  <TableRow key={i}>
                    <TableCell colSpan={6}>
                      <Skeleton className="h-10 w-full" />
                    </TableCell>
                  </TableRow>
                ))}
              {!isLoading &&
                pageRows.map((r) => (
                  <TableRow key={r.id}>
                    <TableCell>
                      <div className="flex flex-col gap-0.5">
                        <Link
                          to={`/rides/${r.id}`}
                          className="font-medium underline-offset-4 hover:underline focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring rounded-sm"
                        >
                          {formatRouteLabel(r.origin, r.destination, locale)}
                        </Link>
                        <span className="text-muted-foreground text-xs">
                          {r.id}
                        </span>
                      </div>
                    </TableCell>
                    <TableCell>{r.driverName}</TableCell>
                    <TableCell className="text-muted-foreground text-sm">
                      {formatRideDeparture(r.departureAt, locale)}
                    </TableCell>
                    <TableCell className="text-right tabular-nums">
                      {r.seatsTaken}/{r.seatsTotal}
                    </TableCell>
                    <TableCell className="text-right tabular-nums">
                      {formatNumber(r.fareShare)}
                      {r.currency ? ` ${r.currency}` : ''}
                    </TableCell>
                    <TableCell>{rideStatusBadge(r.status, t)}</TableCell>
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
