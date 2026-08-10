import { Link, useParams } from 'react-router-dom'
import { ArrowLeft } from 'lucide-react'
import { Badge } from '@/components/ui/badge'
import { buttonVariants } from '@/components/ui/button'
import { cn } from '@/lib/utils'
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table'
import { Skeleton } from '@/components/ui/skeleton'
import { ApiError } from '@/api/http'
import { useUserDetail } from '@/hooks/use-admin-queries'
import {
  formatDateTime,
  formatNumber,
  formatRideDeparture,
  formatRouteLabel,
} from '@/lib/format'
import { rideDetailPath, rideRouteLabel } from '@/lib/ride-links'
import type { BookingPayment, BookingStatus, RideStatus, UserRole, UserStatus } from '@/types/domain'
import { useI18n } from '@/contexts/i18n'

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

export function UserDetailPage() {
  const { userId } = useParams<{ userId: string }>()
  const { locale, t } = useI18n()
  const { data, isLoading, isError, error } = useUserDetail(userId)

  if (isError) {
    const notFound = error instanceof ApiError && error.status === 404
    return (
      <div className="space-y-4">
        <Link
          to="/users"
          className={cn(
            buttonVariants({ variant: 'ghost', size: 'sm' }),
            'inline-flex w-fit gap-1 px-0',
          )}
        >
          <ArrowLeft className="size-4 rtl:rotate-180" />
          {t('users.detail.back')}
        </Link>
        <p className="text-destructive text-sm">
          {notFound ? t('users.detail.notFound') : t('users.error')}
        </p>
      </div>
    )
  }

  if (isLoading || !data) {
    return (
      <div className="space-y-4">
        <Skeleton className="h-9 w-40" />
        <Skeleton className="h-40 w-full max-w-2xl rounded-xl" />
        <Skeleton className="h-48 w-full rounded-xl" />
      </div>
    )
  }

  const { user, transactions, ridesAsDriver, bookingsAsRider, rideRows } = data
  const isDriver = user.role === 'driver'
  const isPassenger = user.role === 'passenger'

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <Link
          to="/users"
          className={cn(
            buttonVariants({ variant: 'ghost', size: 'sm' }),
            'inline-flex w-fit gap-1 px-0',
          )}
        >
          <ArrowLeft className="size-4 rtl:rotate-180" />
          {t('users.detail.back')}
        </Link>
      </div>

      <div>
        <h2 className="text-2xl font-semibold tracking-tight">
          {t('users.detail.title', { name: user.fullName })}
        </h2>
        <p className="text-muted-foreground mt-1 text-sm max-w-2xl">
          {t('users.detail.subtitle')}
        </p>
      </div>

      <Card className="max-w-2xl">
        <CardHeader>
          <CardTitle className="text-base">{t('users.detail.profile')}</CardTitle>
          <CardDescription>{user.email || '—'}</CardDescription>
        </CardHeader>
        <CardContent className="grid gap-3 text-sm sm:grid-cols-2">
          <div className="space-y-1">
            <p className="text-muted-foreground">{t('users.table.role')}</p>
            <p className="font-medium">{roleLabel(user.role, t)}</p>
          </div>
          <div className="space-y-1">
            <p className="text-muted-foreground">{t('users.table.status')}</p>
            <div>{statusBadge(user.status, t)}</div>
          </div>
          <div className="space-y-1">
            <p className="text-muted-foreground">{t('users.table.joined')}</p>
            <p className="font-medium">{formatDateTime(user.createdAt, locale)}</p>
          </div>
          <div className="space-y-1">
            <p className="text-muted-foreground">{t('users.detail.userId')}</p>
            <p className="font-mono text-xs">{user.id}</p>
          </div>
          {user.balance != null ? (
            <div className="space-y-1">
              <p className="text-muted-foreground">{t('users.detail.balance')}</p>
              <p className="tabular-nums font-medium">
                {formatNumber(user.balance)}
              </p>
            </div>
          ) : null}
        </CardContent>
      </Card>

      {transactions.length > 0 ? (
        <Card>
          <CardHeader>
            <CardTitle className="text-base">
              {t('users.detail.transactions')}
            </CardTitle>
            <CardDescription>
              {t('users.detail.transactionsHint')}
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="rounded-md border">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>{t('users.detail.txn.type')}</TableHead>
                    <TableHead className="text-start">
                      {t('users.detail.txn.amount')}
                    </TableHead>
                    <TableHead>{t('users.detail.txn.date')}</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {transactions.map((txn) => (
                    <TableRow key={txn.id}>
                      <TableCell className="capitalize">{txn.type}</TableCell>
                      <TableCell className="text-right tabular-nums">
                        {formatNumber(txn.amount)}
                      </TableCell>
                      <TableCell className="text-muted-foreground text-sm">
                        {formatDateTime(txn.createdAt, locale)}
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          </CardContent>
        </Card>
      ) : null}

      {isDriver ? (
        <Card>
          <CardHeader>
            <CardTitle className="text-base">{t('users.detail.ridesAsDriver')}</CardTitle>
            <CardDescription>{t('users.detail.ridesAsDriverHint')}</CardDescription>
          </CardHeader>
          <CardContent>
            {ridesAsDriver.length === 0 ? (
              <p className="text-muted-foreground text-sm">{t('users.detail.noDriverRides')}</p>
            ) : (
              <div className="rounded-md border">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>{t('rides.table.route')}</TableHead>
                      <TableHead>{t('rides.table.departure')}</TableHead>
                      <TableHead className="text-start">{t('rides.table.seats')}</TableHead>
                      <TableHead className="text-start">{t('rides.table.fare')}</TableHead>
                      <TableHead>{t('rides.table.status')}</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {ridesAsDriver.map((r) => (
                      <TableRow key={r.id}>
                        <TableCell>
                          <Link
                            to={rideDetailPath(r.id, r.origin, r.destination)}
                            className="font-medium underline-offset-4 hover:underline focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring rounded-sm"
                          >
                            {formatRouteLabel(r.origin, r.destination, locale)}
                          </Link>
                          <div className="text-muted-foreground text-xs">{r.id}</div>
                        </TableCell>
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
              </div>
            )}
          </CardContent>
        </Card>
      ) : null}

      {isPassenger ? (
        <Card>
          <CardHeader>
            <CardTitle className="text-base">{t('users.detail.reservationsAsRider')}</CardTitle>
            <CardDescription>{t('users.detail.reservationsAsRiderHint')}</CardDescription>
          </CardHeader>
          <CardContent>
            {bookingsAsRider.length === 0 ? (
              <p className="text-muted-foreground text-sm">{t('users.detail.noRiderBookings')}</p>
            ) : (
              <div className="rounded-md border">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>{t('bookings.table.ride')}</TableHead>
                      <TableHead>{t('bookings.table.status')}</TableHead>
                      <TableHead>{t('bookings.table.payment')}</TableHead>
                      <TableHead>{t('bookings.table.requested')}</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {bookingsAsRider.map((b) => {
                      const label = b.rideLocation && b.rideDestination
                        ? formatRouteLabel(b.rideLocation, b.rideDestination, locale)
                        : rideRouteLabel(b.rideId, rideRows, locale)
                      const to = rideDetailPath(
                        b.rideId,
                        b.rideLocation,
                        b.rideDestination,
                      )
                      return (
                        <TableRow key={b.id}>
                          <TableCell>
                            {b.rideId ? (
                              <>
                                <Link
                                  to={to}
                                  className="font-medium underline-offset-4 hover:underline focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring rounded-sm"
                                >
                                  {label}
                                </Link>
                                <div className="text-muted-foreground text-xs">
                                  {b.rideId}
                                </div>
                              </>
                            ) : (
                              <span className="font-medium">{label}</span>
                            )}
                          </TableCell>
                          <TableCell>{bookingBadge(b.status, t)}</TableCell>
                          <TableCell>{paymentBadge(b.payment, t)}</TableCell>
                          <TableCell className="text-muted-foreground text-sm">
                            {formatDateTime(b.createdAt, locale)}
                          </TableCell>
                        </TableRow>
                      )
                    })}
                  </TableBody>
                </Table>
              </div>
            )}
          </CardContent>
        </Card>
      ) : null}

      {!isDriver && !isPassenger ? (
        <Card>
          <CardHeader>
            <CardTitle className="text-base">{t('users.detail.otherAccount')}</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-muted-foreground text-sm">
              {t('users.detail.noRoleSpecificData')}
            </p>
          </CardContent>
        </Card>
      ) : null}
    </div>
  )
}
