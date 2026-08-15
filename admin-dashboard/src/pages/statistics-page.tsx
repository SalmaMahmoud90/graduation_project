import { useMemo } from 'react'
import { Link } from 'react-router-dom'
import { DashboardOverviewChart } from '@/components/dashboard-overview-chart'
import { DailySummaryChart } from '@/components/daily-summary-chart'
import { ListEmptyState } from '@/components/empty-state'
import { Skeleton } from '@/components/ui/skeleton'
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
import { Users } from 'lucide-react'
import {
  useDailySummary,
  useDashboardStatistics,
  useUsers,
} from '@/hooks/use-admin-queries'
import { formatDate, formatNumber } from '@/lib/format'
import { useI18n } from '@/contexts/i18n'
import type { User } from '@/types/domain'

/** How many rows/bars to show in the "top" lists and charts. */
const TOP_N = 8
const TABLE_ROWS = 10

/**
 * The statistics views expose driver/rider email but no display name, and their
 * `*_id` is the driver/rider profile id — not the main user id the user page
 * expects. Resolve both from the users list by matching on email.
 */
function UserCell({
  email,
  user,
}: {
  email: string
  user: User | undefined
}) {
  const hasName = Boolean(user && user.fullName && user.fullName !== email)
  if (!user) {
    return <span>{email || '—'}</span>
  }
  return (
    <Link
      to={`/users/${user.id}`}
      className="inline-flex flex-col rounded-sm hover:text-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
    >
      <span className="text-primary hover:underline">
        {hasName ? user.fullName : email}
      </span>
      {hasName ? (
        <span className="text-muted-foreground text-xs font-normal">
          {email}
        </span>
      ) : null}
    </Link>
  )
}

export function StatisticsPage() {
  const { t } = useI18n()
  const statistics = useDashboardStatistics()
  const dailySummary = useDailySummary()
  // Loaded in the background to resolve emails → names + user page links. The
  // page renders without waiting for it; names/links fill in once it arrives.
  const users = useUsers()

  const isLoading = statistics.isLoading || dailySummary.isLoading
  const isError = statistics.isError || dailySummary.isError

  const userByEmail = useMemo(() => {
    const map = new Map<string, User>()
    for (const u of users.data ?? []) {
      if (u.email) map.set(u.email.toLowerCase(), u)
    }
    return map
  }, [users.data])

  const destinationChart = useMemo(() => {
    const rows = statistics.data?.popular_destinations ?? []
    return [...rows]
      .sort((a, b) => b.total_trips_to_destination - a.total_trips_to_destination)
      .slice(0, TOP_N)
      .map((r) => ({
        name: r.destination_city || '—',
        value: r.total_trips_to_destination,
      }))
  }, [statistics.data])

  const pickupChart = useMemo(() => {
    const rows = statistics.data?.popular_pickup_locations ?? []
    return [...rows]
      .sort((a, b) => b.total_requests - a.total_requests)
      .slice(0, TOP_N)
      .map((r) => ({
        name: r.student_pickup_point || '—',
        value: r.total_requests,
      }))
  }, [statistics.data])

  const topDrivers = useMemo(() => {
    const rows = statistics.data?.driver_trips ?? []
    return [...rows]
      .sort((a, b) => b.total_rides - a.total_rides)
      .slice(0, TABLE_ROWS)
  }, [statistics.data])

  const topRiders = useMemo(() => {
    const rows = statistics.data?.active_riders ?? []
    return [...rows]
      .sort((a, b) => b.total_reservations - a.total_reservations)
      .slice(0, TABLE_ROWS)
  }, [statistics.data])

  // The API returns rows newest-first; a time series needs oldest-first.
  const dailyChart = useMemo(() => {
    const rows = dailySummary.data ?? []
    return [...rows]
      .sort((a, b) => a.summary_date.localeCompare(b.summary_date))
      .map((r) => ({
        date: r.summary_date,
        rides: Number(r.total_rides_created) || 0,
        reservations: Number(r.total_reservations_made) || 0,
      }))
  }, [dailySummary.data])

  if (isError) {
    return <p className="text-destructive text-sm">{t('statistics.error')}</p>
  }

  if (isLoading) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-72 rounded-xl" />
        <div className="grid gap-4 lg:grid-cols-2">
          <Skeleton className="h-72 rounded-xl" />
          <Skeleton className="h-72 rounded-xl" />
        </div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-semibold tracking-tight">
          {t('statistics.title')}
        </h2>
        <p className="text-muted-foreground mt-1 text-sm max-w-2xl">
          {t('statistics.description')}
        </p>
      </div>

      <DailySummaryChart
        data={dailyChart}
        title={t('statistics.daily.title')}
        description={t('statistics.daily.description')}
      />

      <div className="grid gap-4 lg:grid-cols-2">
        <DashboardOverviewChart
          data={destinationChart}
          title={t('statistics.destinations.title')}
          description={t('statistics.destinations.description')}
        />
        <DashboardOverviewChart
          data={pickupChart}
          title={t('statistics.pickups.title')}
          description={t('statistics.pickups.description')}
        />
      </div>

      <div className="grid gap-4 lg:grid-cols-2">
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-base">
              {t('statistics.drivers.title')}
            </CardTitle>
            <CardDescription>
              {t('statistics.drivers.description')}
            </CardDescription>
          </CardHeader>
          <CardContent>
            {topDrivers.length === 0 ? (
              <ListEmptyState
                icon={Users}
                title={t('statistics.drivers.emptyTitle')}
                description={t('statistics.drivers.emptyDescription')}
              />
            ) : (
              <div className="overflow-x-auto">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>{t('statistics.table.driver')}</TableHead>
                      <TableHead className="text-end">
                        {t('statistics.table.trips')}
                      </TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {topDrivers.map((row) => (
                      <TableRow key={row.driver_id}>
                        <TableCell className="font-medium">
                          <UserCell
                            email={row.driver_email}
                            user={userByEmail.get(
                              row.driver_email.toLowerCase(),
                            )}
                          />
                        </TableCell>
                        <TableCell className="text-end tabular-nums">
                          {formatNumber(row.total_rides)}
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </div>
            )}
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-base">
              {t('statistics.riders.title')}
            </CardTitle>
            <CardDescription>
              {t('statistics.riders.description')}
            </CardDescription>
          </CardHeader>
          <CardContent>
            {topRiders.length === 0 ? (
              <ListEmptyState
                icon={Users}
                title={t('statistics.riders.emptyTitle')}
                description={t('statistics.riders.emptyDescription')}
              />
            ) : (
              <div className="overflow-x-auto">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>{t('statistics.table.rider')}</TableHead>
                      <TableHead className="text-end">
                        {t('statistics.table.reservations')}
                      </TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {topRiders.map((row) => (
                      <TableRow key={row.rider_id}>
                        <TableCell className="font-medium">
                          <UserCell
                            email={row.rider_email}
                            user={userByEmail.get(
                              row.rider_email.toLowerCase(),
                            )}
                          />
                        </TableCell>
                        <TableCell className="text-end tabular-nums">
                          {formatNumber(row.total_reservations)}
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

      {dailyChart.length > 0 ? (
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-base">
              {t('statistics.dailyTable.title')}
            </CardTitle>
            <CardDescription>
              {t('statistics.dailyTable.description')}
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>{t('statistics.dailyTable.date')}</TableHead>
                    <TableHead className="text-end">
                      {t('statistics.dailyTable.rides')}
                    </TableHead>
                    <TableHead className="text-end">
                      {t('statistics.dailyTable.reservations')}
                    </TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {[...dailyChart].reverse().map((row) => (
                    <TableRow key={row.date}>
                      <TableCell className="font-medium">
                        {formatDate(row.date)}
                      </TableCell>
                      <TableCell className="text-end tabular-nums">
                        {formatNumber(row.rides)}
                      </TableCell>
                      <TableCell className="text-end tabular-nums">
                        {formatNumber(row.reservations)}
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          </CardContent>
        </Card>
      ) : null}
    </div>
  )
}
