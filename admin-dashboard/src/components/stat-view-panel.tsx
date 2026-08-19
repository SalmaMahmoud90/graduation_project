import { useMemo, type ReactNode } from 'react'
import { Link } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { DashboardOverviewChart } from '@/components/dashboard-overview-chart'
import { ListEmptyState } from '@/components/empty-state'
import { Skeleton } from '@/components/ui/skeleton'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table'
import { Database } from 'lucide-react'
import { useStatisticsView } from '@/hooks/use-admin-queries'
import { fetchDashboardRides, fetchDashboardUsers } from '@/api/dashboard-api'
import { mapApiRide, mapApiUser } from '@/lib/map-dashboard'
import { qk } from '@/api/query-keys'
import {
  ACTIVITY_AREA_LABELS,
  COLUMN_LABELS,
  ROLE_LABELS,
  type StatViewConfig,
} from '@/lib/stat-views'
import {
  formatDate,
  formatDateTime,
  formatNumber,
  formatRouteLabel,
} from '@/lib/format'
import { useI18n } from '@/contexts/i18n'
import type { Locale } from '@/i18n/translations'
import type { Ride, User } from '@/types/domain'

/** Top-N rows to plot / list, keeping dense reports readable. */
const TOP_N = 12
const MAX_TABLE_ROWS = 50
const LOOKUP_STALE_TIME = 5 * 60 * 1000

type CellValue = string | number | boolean | null

/** Turn a raw column name into a header, e.g. `total_rides` → "Total rides". */
function humanizeColumn(column: string): string {
  const cleaned = column.replace(/_/g, ' ').trim()
  return cleaned.charAt(0).toUpperCase() + cleaned.slice(1)
}

/** Business-friendly, localized header for a column. */
function columnLabel(column: string, locale: Locale): string {
  return COLUMN_LABELS[column]?.[locale] ?? humanizeColumn(column)
}

function isDateColumn(column: string): boolean {
  return /(_at|_date|^log_date$|last_login|earliest|latest|updated|recorded)/.test(
    column,
  )
}

function asNumber(value: CellValue): number | null {
  if (typeof value === 'number') return value
  if (typeof value === 'string' && value.trim() !== '' && !isNaN(Number(value))) {
    return Number(value)
  }
  return null
}

/** Best-effort, localized formatting for a plain (non-entity) cell. */
function formatCell(column: string, value: CellValue, locale: string): string {
  if (value === null || value === undefined || value === '') return '—'
  if (typeof value === 'boolean') return value ? '✓' : '—'

  const str = String(value)

  if (column === 'user_type') return ROLE_LABELS[str]?.[locale as Locale] ?? str
  if (column === 'table_name') {
    return ACTIVITY_AREA_LABELS[str]?.[locale as Locale] ?? humanizeColumn(str)
  }
  // A calendar hour, e.g. "2026-08-19 14:00" — keep the time of day.
  if (column === 'hour_bucket') {
    return formatDateTime(str.replace(' ', 'T'), locale)
  }
  if (isDateColumn(column)) return formatDate(str, locale)

  const num = asNumber(value)
  if (num !== null) {
    // IDs read better without thousands separators.
    if (column === 'id' || /_id$/.test(column)) return str
    if (/percent|percentage|rate/.test(column)) return `${formatNumber(num)}%`
    return formatNumber(num)
  }

  return str
}

/** Right-align numeric (non-date, non-entity) columns. */
function isNumericColumn(
  rows: Array<Record<string, CellValue>>,
  column: string,
): boolean {
  if (isDateColumn(column)) return false
  for (const row of rows) {
    const v = row[column]
    if (v === null || v === undefined || v === '') continue
    return asNumber(v) !== null
  }
  return false
}

function EntityLink({ to, label }: { to: string | null; label: string }) {
  if (!to) return <span>{label}</span>
  return (
    <Link
      to={to}
      className="text-primary hover:underline focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring rounded-sm"
    >
      {label}
    </Link>
  )
}

export function StatViewPanel({ config }: { config: StatViewConfig }) {
  const { locale, t } = useI18n()
  const query = useStatisticsView(config.key)

  const resolvers = config.resolve ?? {}
  const needUsers = Object.values(resolvers).some(
    (k) => k === 'userById' || k === 'userByEmail',
  )
  const needRides = Object.values(resolvers).some((k) => k === 'rideById')

  // Loaded (and cached, shared with the other pages) only when this report has
  // ids to turn into names. Names fill in once the lookup arrives.
  const usersQuery = useQuery({
    queryKey: qk.users,
    queryFn: async () => (await fetchDashboardUsers()).map(mapApiUser),
    enabled: needUsers,
    staleTime: LOOKUP_STALE_TIME,
  })
  const ridesQuery = useQuery({
    queryKey: qk.rides,
    queryFn: async () => (await fetchDashboardRides()).map(mapApiRide),
    enabled: needRides,
    staleTime: LOOKUP_STALE_TIME,
  })

  const usersById = useMemo(() => {
    const map = new Map<string, User>()
    for (const u of usersQuery.data ?? []) map.set(u.id, u)
    return map
  }, [usersQuery.data])

  const usersByEmail = useMemo(() => {
    const map = new Map<string, User>()
    for (const u of usersQuery.data ?? []) {
      if (u.email) map.set(u.email.toLowerCase(), u)
    }
    return map
  }, [usersQuery.data])

  const ridesById = useMemo(() => {
    const map = new Map<string, Ride>()
    for (const r of ridesQuery.data ?? []) map.set(r.id, r)
    return map
  }, [ridesQuery.data])

  const rows = useMemo(
    () => (query.data?.rows ?? []) as Array<Record<string, CellValue>>,
    [query.data],
  )
  const columns = useMemo(
    () => (query.data?.columns ?? []).filter((c) => !config.hide?.includes(c)),
    [query.data, config.hide],
  )

  const barData = useMemo(() => {
    if (config.kind !== 'bar' || !config.bar) return []
    const { labelKey, valueKey } = config.bar
    return [...rows]
      .map((r) => ({
        name: String(r[labelKey] ?? '—') || '—',
        value: asNumber(r[valueKey]) ?? 0,
      }))
      .sort((a, b) => b.value - a.value)
      .slice(0, TOP_N)
  }, [rows, config])

  /** Render one cell: resolve entity references to names, else format. */
  function renderCell(column: string, value: CellValue): ReactNode {
    const kind = resolvers[column]
    if (kind === 'userById') {
      const user = usersById.get(String(value))
      return (
        <EntityLink
          to={user ? `/users/${user.id}` : null}
          label={user?.fullName ?? `#${String(value)}`}
        />
      )
    }
    if (kind === 'userByEmail') {
      const user = usersByEmail.get(String(value).toLowerCase())
      return (
        <EntityLink
          to={user ? `/users/${user.id}` : null}
          label={user?.fullName ?? (String(value) || '—')}
        />
      )
    }
    if (kind === 'rideById') {
      const ride = ridesById.get(String(value))
      return (
        <EntityLink
          to={`/rides/${String(value)}`}
          label={
            ride ? formatRouteLabel(ride.origin, ride.destination, locale) : `#${String(value)}`
          }
        />
      )
    }
    return formatCell(column, value, locale)
  }

  if (query.isLoading) {
    return (
      <div className="space-y-4">
        <Skeleton className="h-8 w-56 rounded-md" />
        <Skeleton className="h-64 rounded-xl" />
      </div>
    )
  }

  if (query.isError) {
    return (
      <div className="rounded-xl border border-destructive/30 bg-destructive/5 p-6 text-sm text-destructive">
        {t('statistics.views.error')}
      </div>
    )
  }

  const header = (
    <div className="flex items-start justify-between gap-4">
      <div>
        <h3 className="text-lg font-semibold tracking-tight">
          {config.label[locale]}
        </h3>
        <p className="text-muted-foreground mt-0.5 text-sm max-w-xl">
          {config.description[locale]}
        </p>
      </div>
      <span className="shrink-0 rounded-full bg-secondary px-3 py-1 text-xs font-medium text-secondary-foreground tabular-nums">
        {t('statistics.views.rowCount', { count: formatNumber(rows.length) })}
      </span>
    </div>
  )

  if (rows.length === 0) {
    return (
      <div className="space-y-4">
        {header}
        <ListEmptyState
          icon={Database}
          title={t('statistics.views.emptyTitle')}
          description={t('statistics.views.emptyDescription')}
        />
      </div>
    )
  }

  // KPI: render the single summary row as a grid of headline stat cards.
  if (config.kind === 'kpi') {
    const row = rows[0]
    return (
      <div className="space-y-4">
        {header}
        <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-3">
          {columns.map((col) => (
            <div
              key={col}
              className="rounded-xl border bg-card p-5 shadow-sm transition-shadow hover:shadow-md"
            >
              <p className="text-muted-foreground text-xs font-medium uppercase tracking-wide">
                {columnLabel(col, locale)}
              </p>
              <p className="text-primary mt-2 text-3xl font-semibold tabular-nums">
                {formatCell(col, row[col], locale)}
              </p>
            </div>
          ))}
        </div>
      </div>
    )
  }

  // Bar: a labelled category count, plus a compact ranked table underneath.
  if (config.kind === 'bar' && config.bar) {
    const { labelKey, valueKey } = config.bar
    return (
      <div className="space-y-4">
        {header}
        <DashboardOverviewChart
          data={barData}
          title={config.label[locale]}
          description={config.description[locale]}
        />
        <div className="overflow-x-auto rounded-xl border">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>{columnLabel(labelKey, locale)}</TableHead>
                <TableHead className="text-end">
                  {columnLabel(valueKey, locale)}
                </TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {barData.map((r) => (
                <TableRow key={r.name}>
                  <TableCell className="font-medium">{r.name}</TableCell>
                  <TableCell className="text-end tabular-nums">
                    {formatNumber(r.value)}
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </div>
      </div>
    )
  }

  // Table: records rendered from the resolved columns.
  const numericByColumn = new Map(
    columns.map((c) => [c, !resolvers[c] && isNumericColumn(rows, c)]),
  )
  const visibleRows = rows.slice(0, MAX_TABLE_ROWS)

  return (
    <div className="space-y-4">
      {header}
      <div className="overflow-x-auto rounded-xl border">
        <Table>
          <TableHeader>
            <TableRow>
              {columns.map((col) => (
                <TableHead
                  key={col}
                  className={numericByColumn.get(col) ? 'text-end' : undefined}
                >
                  {columnLabel(col, locale)}
                </TableHead>
              ))}
            </TableRow>
          </TableHeader>
          <TableBody>
            {visibleRows.map((row, i) => (
              <TableRow key={i}>
                {columns.map((col) => (
                  <TableCell
                    key={col}
                    className={
                      numericByColumn.get(col)
                        ? 'text-end tabular-nums'
                        : resolvers[col]
                          ? 'font-medium'
                          : undefined
                    }
                  >
                    {renderCell(col, row[col])}
                  </TableCell>
                ))}
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
      {rows.length > MAX_TABLE_ROWS ? (
        <p className="text-muted-foreground text-xs">
          {t('statistics.views.truncated', {
            shown: formatNumber(MAX_TABLE_ROWS),
            total: formatNumber(rows.length),
          })}
        </p>
      ) : null}
    </div>
  )
}
