import { useMemo, useState } from 'react'
import { Inbox, Search } from 'lucide-react'
import { toast } from 'sonner'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog'
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
import { TablePagination } from '@/components/table/table-pagination'
import {
  useAcceptDepositRequest,
  useDepositRequestDetail,
  useDepositRequestsPage,
  useRejectDepositRequest,
} from '@/hooks/use-admin-queries'
import { formatDateTime, formatNumber } from '@/lib/format'
import type { DepositRequest, DepositStatus } from '@/types/domain'
import { useI18n } from '@/contexts/i18n'

function statusBadge(status: DepositStatus, t: (key: string) => string) {
  const styles: Record<
    DepositStatus,
    { label: string; variant: 'default' | 'secondary' | 'outline' | 'destructive' }
  > = {
    pending: { label: t('deposits.status.pending'), variant: 'secondary' },
    approved: { label: t('deposits.status.approved'), variant: 'default' },
    rejected: { label: t('deposits.status.rejected'), variant: 'destructive' },
  }
  const s = styles[status]
  return <Badge variant={s.variant}>{s.label}</Badge>
}

function methodLabel(method: string, t: (key: string) => string) {
  const known = ['syriatel_cash', 'mtn_cash', 'sham_cash']
  return known.includes(method) ? t(`deposits.method.${method}`) : method
}

function DetailDialog({ id }: { id: string }) {
  const { t } = useI18n()
  const [open, setOpen] = useState(false)
  const { data, isLoading } = useDepositRequestDetail(open ? id : undefined)

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger
        render={
          <Button size="sm" variant="outline">
            {t('deposits.action.view')}
          </Button>
        }
      />
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{t('deposits.detail.title')}</DialogTitle>
          <DialogDescription>{t('deposits.detail.subtitle')}</DialogDescription>
        </DialogHeader>
        {isLoading || !data ? (
          <Skeleton className="h-24 w-full" />
        ) : (
          <dl className="grid grid-cols-[auto_1fr] gap-x-4 gap-y-2 text-sm">
            <dt className="text-muted-foreground">{t('deposits.table.user')}</dt>
            <dd className="font-medium">{data.userName}</dd>
            <dt className="text-muted-foreground">{t('deposits.table.method')}</dt>
            <dd>{methodLabel(data.paymentMethod, t)}</dd>
            <dt className="text-muted-foreground">{t('deposits.table.amount')}</dt>
            <dd className="tabular-nums">{formatNumber(data.amount)}</dd>
            <dt className="text-muted-foreground">{t('deposits.detail.reference')}</dt>
            <dd className="break-all">{data.transactionReference || '—'}</dd>
            <dt className="text-muted-foreground">{t('deposits.table.status')}</dt>
            <dd>{statusBadge(data.status, t)}</dd>
          </dl>
        )}
        <DialogFooter showCloseButton />
      </DialogContent>
    </Dialog>
  )
}

export function DepositRequestsPage() {
  const { locale, t } = useI18n()
  const [query, setQuery] = useState('')
  const [page, setPage] = useState(1)
  const [pageSize, setPageSize] = useState(10)
  const { data, isLoading, isError } = useDepositRequestsPage(page, pageSize)
  const accept = useAcceptDepositRequest()
  const reject = useRejectDepositRequest()

  const filtered = useMemo(() => {
    if (!data) return []
    const q = query.trim().toLowerCase()
    if (!q) return data.results
    return data.results.filter(
      (d) =>
        d.userName.toLowerCase().includes(q) ||
        d.id.toLowerCase().includes(q) ||
        d.paymentMethod.toLowerCase().includes(q),
    )
  }, [data, query])

  const hasNext = Boolean(data?.next)
  const total =
    data?.count ??
    (hasNext ? page * pageSize : (page - 1) * pageSize + filtered.length)
  const totalPages = data?.count
    ? Math.max(1, Math.ceil(data.count / pageSize))
    : Math.max(1, page + (hasNext ? 1 : 0))

  function runAccept(d: DepositRequest) {
    accept.mutate(d.id, {
      onSuccess: () => toast.success(t('deposits.accept.success')),
      onError: () => toast.error(t('deposits.action.error')),
    })
  }

  function runReject(d: DepositRequest) {
    reject.mutate(d.id, {
      onSuccess: () => toast.success(t('deposits.reject.success')),
      onError: () => toast.error(t('deposits.action.error')),
    })
  }

  if (isError) {
    return <p className="text-destructive text-sm">{t('deposits.error')}</p>
  }

  const showFilterEmpty =
    !isLoading && data && filtered.length === 0 && query.trim() !== ''
  const showNoData = !isLoading && data && data.results.length === 0

  return (
    <div className="space-y-4">
      <div className="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
        <div>
          <h2 className="text-2xl font-semibold tracking-tight">
            {t('deposits.title')}
          </h2>
          <p className="text-muted-foreground mt-1 text-sm max-w-xl">
            {t('deposits.description')}
          </p>
        </div>
        <div className="w-full sm:max-w-xs">
          <Input
            placeholder={t('deposits.searchPlaceholder')}
            value={query}
            onChange={(e) => {
              setQuery(e.target.value)
              setPage(1)
            }}
            aria-label={t('deposits.searchAria')}
          />
        </div>
      </div>

      <p className="text-muted-foreground text-xs md:hidden">
        {t('table.scrollHint')}
      </p>

      {showNoData ? (
        <ListEmptyState
          icon={Inbox}
          title={t('emptyState.deposits.noneTitle')}
          description={t('emptyState.deposits.noneDescription')}
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
                <TableHead>{t('deposits.table.user')}</TableHead>
                <TableHead>{t('deposits.table.method')}</TableHead>
                <TableHead>{t('deposits.table.amount')}</TableHead>
                <TableHead>{t('deposits.table.status')}</TableHead>
                <TableHead>{t('deposits.table.created')}</TableHead>
                <TableHead className="text-start">
                  {t('deposits.table.actions')}
                </TableHead>
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
                filtered.map((d) => (
                  <TableRow key={d.id}>
                    <TableCell>
                      <div className="flex flex-col">
                        <span className="font-medium">{d.userName}</span>
                        <span className="text-muted-foreground text-xs">
                          {d.id}
                        </span>
                      </div>
                    </TableCell>
                    <TableCell>
                      <Badge variant="outline" className="font-normal">
                        {methodLabel(d.paymentMethod, t)}
                      </Badge>
                    </TableCell>
                    <TableCell className="tabular-nums">
                      {formatNumber(d.amount)}
                    </TableCell>
                    <TableCell>{statusBadge(d.status, t)}</TableCell>
                    <TableCell className="text-muted-foreground text-sm">
                      {formatDateTime(d.createdAt, locale)}
                    </TableCell>
                    <TableCell>
                      <div className="flex items-center gap-2">
                        <DetailDialog id={d.id} />
                        {d.status === 'pending' ? (
                          <>
                            <Button
                              size="sm"
                              variant="default"
                              disabled={accept.isPending || reject.isPending}
                              onClick={() => runAccept(d)}
                            >
                              {t('deposits.action.accept')}
                            </Button>
                            <Button
                              size="sm"
                              variant="destructive"
                              disabled={accept.isPending || reject.isPending}
                              onClick={() => runReject(d)}
                            >
                              {t('deposits.action.reject')}
                            </Button>
                          </>
                        ) : null}
                      </div>
                    </TableCell>
                  </TableRow>
                ))}
            </TableBody>
          </Table>
          {!isLoading && filtered.length > 0 ? (
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
