import { useMemo } from 'react'
import { Link } from 'react-router-dom'
import { DashboardOverviewChart } from '@/components/dashboard-overview-chart'
import { Skeleton } from '@/components/ui/skeleton'
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card'
import { useDashboardStats } from '@/hooks/use-admin-queries'
import { formatNumber } from '@/lib/format'
import { useI18n } from '@/contexts/i18n'

export function DashboardPage() {
  const { t } = useI18n()
  const { data, isLoading, isError } = useDashboardStats()

  const loading = isLoading

  const chartData = useMemo(() => {
    if (!data) return []
    return [
      { name: t('dashboard.tiles.users.title'), value: data.totalUsers },
      { name: t('dashboard.tiles.rides.title'), value: data.totalRides },
      { name: t('dashboard.tiles.bookings.title'), value: data.totalBookings },
      { name: t('dashboard.tiles.drivers.title'), value: data.driverAccounts },
      { name: t('dashboard.tiles.passengers.title'), value: data.passengerAccounts },
      { name: t('dashboard.tiles.reports.title'), value: data.openReports },
    ]
  }, [data, t])

  if (isError) {
    return (
      <p className="text-destructive text-sm">
        {t('dashboard.error')}
      </p>
    )
  }

  if (loading || !data) {
    return (
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {Array.from({ length: 7 }).map((_, i) => (
          <Skeleton key={i} className="h-28 rounded-xl" />
        ))}
      </div>
    )
  }

  const tiles = [
    {
      title: t('dashboard.tiles.users.title'),
      value: formatNumber(data.totalUsers),
      hint: t('dashboard.tiles.users.hint', {
        active: formatNumber(data.activeUsers),
        banned: formatNumber(data.bannedUsers),
      }),
      to: '/users',
    },
    {
      title: t('dashboard.tiles.rides.title'),
      value: formatNumber(data.totalRides),
      hint: t('dashboard.tiles.rides.hint', {
        count: formatNumber(data.activeRides),
      }),
      to: '/rides',
    },
    {
      title: t('dashboard.tiles.bookings.title'),
      value: formatNumber(data.totalBookings),
      hint: t('dashboard.tiles.bookings.hint', {
        count: formatNumber(data.pendingBookings),
      }),
      to: '/bookings',
    },
    {
      title: t('dashboard.tiles.drivers.title'),
      value: formatNumber(data.driverAccounts),
      hint: t('dashboard.tiles.drivers.hint'),
      to: '/users',
    },
    {
      title: t('dashboard.tiles.passengers.title'),
      value: formatNumber(data.passengerAccounts),
      hint: t('dashboard.tiles.passengers.hint'),
      to: '/users',
    },
    {
      title: t('dashboard.tiles.reports.title'),
      value: formatNumber(data.openReports),
      hint: t('dashboard.tiles.reports.hint'),
      to: '/reports',
    },
    {
      title: t('dashboard.tiles.deposits.title'),
      value: formatNumber(data.pendingDepositRequests),
      hint: t('dashboard.tiles.deposits.hint'),
      to: '/deposit-requests',
    },
  ]

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-semibold tracking-tight">
          {t('dashboard.title')}
        </h2>
        <p className="text-muted-foreground mt-1 text-sm max-w-2xl">
          {t('dashboard.description')}
        </p>
      </div>
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {tiles.map((tile) => {
          const to = 'to' in tile ? tile.to : undefined
          const card = (
            <Card className={to ? 'transition-colors hover:bg-muted/50' : undefined}>
              <CardHeader className="pb-2">
                <CardTitle className="text-sm font-medium">{tile.title}</CardTitle>
                <CardDescription className="text-xs">{tile.hint}</CardDescription>
              </CardHeader>
              <CardContent>
                <p className="text-3xl font-semibold tabular-nums">{tile.value}</p>
              </CardContent>
            </Card>
          )
          return to ? (
            <Link
              key={tile.title}
              to={to}
              className="rounded-xl focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
            >
              {card}
            </Link>
          ) : (
            <div key={tile.title}>{card}</div>
          )
        })}
      </div>

      <DashboardOverviewChart
        data={chartData}
        title={t('dashboard.chart.title')}
        description={t('dashboard.chart.description')}
      />
    </div>
  )
}
