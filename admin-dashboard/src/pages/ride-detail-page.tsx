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
import { mapApiReservation, mapApiRide } from '@/lib/map-dashboard'
import {
  formatDateTime,
  formatNumber,
  formatRideDeparture,
  formatRouteLabel,
} from '@/lib/format'
import { useRideDetail } from '@/hooks/use-admin-queries'
import type { BookingPayment, BookingStatus, RideStatus } from '@/types/domain'
import { useI18n } from '@/contexts/i18n'

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

export function RideDetailPage() {
  const { rideId } = useParams<{ rideId: string }>()
  const { locale, t } = useI18n()
  const { data, isLoading, isError, error } = useRideDetail(rideId)

  if (isError) {
    const notFound = error instanceof ApiError && error.status === 404
    return (
      <div className="space-y-4">
        <Link
          to="/rides"
          className={cn(
            buttonVariants({ variant: 'ghost', size: 'sm' }),
            'inline-flex w-fit gap-1 px-0',
          )}
        >
          <ArrowLeft className="size-4 rtl:rotate-180" />
          {t('rides.detail.back')}
        </Link>
        <p className="text-destructive text-sm">
          {notFound ? t('rides.detail.notFound') : t('rides.error')}
        </p>
      </div>
    )
  }

  if (isLoading || !data) {
    return (
      <div className="space-y-4">
        <Skeleton className="h-9 w-40" />
        <Skeleton className="h-48 w-full max-w-2xl rounded-xl" />
        <Skeleton className="h-64 w-full rounded-xl" />
      </div>
    )
  }

  const ride = mapApiRide(data)
  const bookings = data.reservations.map(mapApiReservation)

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <Link
          to="/rides"
          className={cn(
            buttonVariants({ variant: 'ghost', size: 'sm' }),
            'inline-flex w-fit gap-1 px-0',
          )}
        >
          <ArrowLeft className="size-4 rtl:rotate-180" />
          {t('rides.detail.back')}
        </Link>
      </div>

      <div>
        <h2 className="text-2xl font-semibold tracking-tight">
          {t('rides.detail.title', { id: ride.id })}
        </h2>
        <p className="text-muted-foreground mt-1 text-sm max-w-2xl">
          {t('rides.detail.subtitle')}
        </p>
      </div>

      <div className="grid gap-4">
        <Card className="max-w-2xl">
          <CardHeader>
            <CardTitle className="text-base">{t('rides.detail.summary')}</CardTitle>
            <CardDescription>
              {formatRouteLabel(ride.origin, ride.destination, locale)}
            </CardDescription>
          </CardHeader>
          <CardContent className="grid gap-4 sm:grid-cols-2">
            <dl className="space-y-3 text-sm">
              <div>
                <dt className="text-muted-foreground">{t('rides.table.driver')}</dt>
                <dd className="font-medium">{ride.driverName}</dd>
              </div>
              <div>
                <dt className="text-muted-foreground">{t('rides.table.departure')}</dt>
                <dd className="font-medium">
                  {formatRideDeparture(ride.departureAt, locale)}
                </dd>
              </div>
              <div>
                <dt className="text-muted-foreground">{t('rides.table.duration')}</dt>
                <dd className="font-medium">
                  {ride.expectedDuration || '—'}
                </dd>
              </div>
              <div>
                <dt className="text-muted-foreground">{t('rides.table.seats')}</dt>
                <dd className="tabular-nums font-medium">
                  {ride.seatsTaken}/{ride.seatsTotal}
                </dd>
              </div>
              <div>
                <dt className="text-muted-foreground">{t('rides.detail.availableSeats')}</dt>
                <dd className="font-medium">
                  {ride.seatsTotal - ride.seatsTaken}
                </dd>
              </div>
              <div>
                <dt className="text-muted-foreground">{t('rides.table.fare')}</dt>
                <dd className="tabular-nums font-medium">
                  {formatNumber(ride.fareShare)}
                  {ride.currency ? ` ${ride.currency}` : ''}
                </dd>
              </div>
            </dl>
            <div className="flex flex-col gap-2">
              <span className="text-muted-foreground text-sm">
                {t('rides.table.status')}
              </span>
              {rideStatusBadge(ride.status, t)}
            </div>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <CardTitle className="text-base">{t('rides.detail.bookings')}</CardTitle>
          <CardDescription>{t('rides.detail.bookingsHint')}</CardDescription>
        </CardHeader>
        <CardContent>
          {bookings.length === 0 ? (
            <p className="text-muted-foreground text-sm">{t('rides.detail.noBookings')}</p>
          ) : (
            <div className="rounded-md border">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>{t('bookings.table.passenger')}</TableHead>
                    <TableHead>{t('bookings.table.status')}</TableHead>
                    <TableHead>{t('bookings.table.payment')}</TableHead>
                    <TableHead>{t('bookings.table.requested')}</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {bookings.map((b) => (
                    <TableRow key={b.id}>
                      <TableCell className="font-medium">{b.passengerName}</TableCell>
                      <TableCell>{bookingBadge(b.status, t)}</TableCell>
                      <TableCell>{paymentBadge(b.payment, t)}</TableCell>
                      <TableCell className="text-muted-foreground text-sm">
                        {formatDateTime(b.createdAt, locale)}
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  )
}
