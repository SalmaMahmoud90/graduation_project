import { useCallback, useMemo, useState } from 'react'
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
import { useBookingsPage, useRides } from '@/hooks/use-admin-queries'
import type { SortDir } from '@/lib/client-table'
import { sortRows } from '@/lib/client-table'
import { formatDateTime, formatRouteLabel } from '@/lib/format'
import { useTableFiltersStore } from '@/stores/table-filters-store'
import type { Booking, BookingPayment, BookingStatus } from '@/types/domain'
import { useI18n } from '@/contexts/i18n'

const BOOKING_SORT_KEYS = [
  'passenger',
  'ride',
  'status',
  'payment',
  'requested',
] as const
type BookingSortKey = (typeof BOOKING_SORT_KEYS)[number]

function paymentBadge(payment: BookingPayment, t: (key: string) => string) {
  if (payment === 'paid')
    return <Badge variant="default">{t('bookings.payment.paid')}</Badge>
  return (
    <Badge variant="outline" className="font-normal">
      {t('bookings.payment.unpaid')}
    </Badge>
  )
}

function bookingBadge(status: BookingStatus, t: (key: string) => string) {
  const styles: Record<
    BookingStatus,
    { label: string; variant: 'default' | 'secondary' | 'outline' | 'destructive' }
  > = {
    pending: { label: t('bookings.status.pending'), variant: 'secondary' },
    confirmed: { label: t('bookings.status.confirmed'), variant: 'default' },
    rejected: { label: t('bookings.status.rejected'), variant: 'destructive' },
    cancelled: { label: t('bookings.status.cancelled'), variant: 'outline' },
  }
  const s = styles[status]
  return <Badge variant={s.variant}>{s.label}</Badge>
}

function bookingSortValue(
  b: Booking,
  key: BookingSortKey,
  rideLabel: (rideId: string) => string,
): string {
  switch (key) {
    case 'passenger':
      return b.passengerName
    case 'ride':
      return rideLabel(b.rideId)
    case 'status':
      return b.status
    case 'payment':
      return b.payment
    case 'requested':
      return b.createdAt
    default:
      return ''
  }
}

export function BookingsPage() {
  const { locale, t } = useI18n()
  const query = useTableFiltersStore((s) => s.bookingsQuery)
  const setQuery = useTableFiltersStore((s) => s.setBookingsQuery)
  const [page, setPage] = useState(1)
  const [pageSize, setPageSize] = useState(10)
  const { data, isLoading, isError } = useBookingsPage(page, pageSize)
  // Loaded once in the background purely to label rides by route; the table
  // itself is server-paginated and does not wait on this.
  const { data: rides } = useRides()

  const [sortKey, setSortKey] = useState<BookingSortKey>('requested')
  const [sortDir, setSortDir] = useState<SortDir>('desc')

  const rideById = useMemo(() => {
    const m = new Map<string, string>()
    rides?.forEach((r) => {
      m.set(r.id, formatRouteLabel(r.origin, r.destination, locale))
    })
    return m
  }, [rides, locale])

  const rideLabel = useCallback(
    (rideId: string) => rideById.get(rideId) ?? `#${rideId}`,
    [rideById],
  )

  const filtered = useMemo(() => {
    if (!data) return []
    const q = query.trim().toLowerCase()
    if (!q) return data.results
    return data.results.filter(
      (b) =>
        b.passengerName.toLowerCase().includes(q) ||
        b.id.toLowerCase().includes(q) ||
        b.rideId.toLowerCase().includes(q) ||
        rideLabel(b.rideId).toLowerCase().includes(q),
    )
  }, [data, query, rideLabel])

  const sorted = useMemo(
    () =>
      sortRows(filtered, (b) => bookingSortValue(b, sortKey, rideLabel), sortDir),
    [filtered, sortKey, sortDir, rideLabel],
  )

  const pageRows = sorted
  const hasNext = Boolean(data?.next)
  const total =
    data?.count ??
    (hasNext ? page * pageSize : (page - 1) * pageSize + sorted.length)
  const totalPages = data?.count
    ? Math.max(1, Math.ceil(data.count / pageSize))
    : Math.max(1, page + (hasNext ? 1 : 0))

  function handleSort(key: string) {
    if (!BOOKING_SORT_KEYS.includes(key as BookingSortKey)) return
    const k = key as BookingSortKey
    if (k === sortKey) setSortDir((d) => (d === 'asc' ? 'desc' : 'asc'))
    else {
      setSortKey(k)
      setSortDir('asc')
    }
  }

  if (isError) {
    return (
      <p className="text-destructive text-sm">
        {t('bookings.error')}
      </p>
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
            {t('bookings.title')}
          </h2>
          <p className="text-muted-foreground mt-1 text-sm max-w-xl">
            {t('bookings.description')}
          </p>
        </div>
        <div className="w-full sm:max-w-xs">
          <Input
            placeholder={t('bookings.searchPlaceholder')}
            value={query}
            onChange={(e) => {
              setQuery(e.target.value)
              setPage(1)
            }}
            aria-label={t('bookings.searchAria')}
          />
        </div>
      </div>

      <p className="text-muted-foreground text-xs md:hidden">
        {t('table.scrollHint')}
      </p>

      {showNoData ? (
        <ListEmptyState
          icon={Inbox}
          title={t('emptyState.bookings.noneTitle')}
          description={t('emptyState.bookings.noneDescription')}
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
                  label={t('bookings.table.passenger')}
                  sortKey="passenger"
                  activeKey={sortKey}
                  dir={sortDir}
                  onSort={handleSort}
                />
                <SortableTableHead
                  label={t('bookings.table.ride')}
                  sortKey="ride"
                  activeKey={sortKey}
                  dir={sortDir}
                  onSort={handleSort}
                />
                <SortableTableHead
                  label={t('bookings.table.status')}
                  sortKey="status"
                  activeKey={sortKey}
                  dir={sortDir}
                  onSort={handleSort}
                />
                <SortableTableHead
                  label={t('bookings.table.payment')}
                  sortKey="payment"
                  activeKey={sortKey}
                  dir={sortDir}
                  onSort={handleSort}
                />
                <SortableTableHead
                  label={t('bookings.table.requested')}
                  sortKey="requested"
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
                    <TableCell colSpan={5}>
                      <Skeleton className="h-10 w-full" />
                    </TableCell>
                  </TableRow>
                ))}
              {!isLoading &&
                pageRows.map((b) => (
                  <TableRow key={b.id}>
                    <TableCell>
                      <div className="flex flex-col">
                        <span className="font-medium">{b.passengerName}</span>
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="flex flex-col gap-0.5">
                        <Link
                          to={`/rides/${b.rideId}`}
                          className="font-medium underline-offset-4 hover:underline focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring rounded-sm"
                        >
                          {rideLabel(b.rideId)}
                        </Link>
                        <Link
                          to={`/rides/${b.rideId}`}
                          className="text-muted-foreground text-xs w-fit hover:text-foreground hover:underline focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring rounded-sm"
                        >
                          {b.rideId}
                        </Link>
                      </div>
                    </TableCell>
                    <TableCell>{bookingBadge(b.status, t)}</TableCell>
                    <TableCell>{paymentBadge(b.payment, t)}</TableCell>
                    <TableCell className="text-muted-foreground text-sm">
                      {formatDateTime(b.createdAt, locale)}
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
