import {
  CartesianGrid,
  Legend,
  Line,
  LineChart,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from 'recharts'
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card'
import { ListEmptyState } from '@/components/empty-state'
import { CalendarRange } from 'lucide-react'
import { formatDateShort, formatNumber } from '@/lib/format'
import { useI18n } from '@/contexts/i18n'

export type DailySummaryDatum = {
  date: string
  rides: number
  reservations: number
}

type DailySummaryChartProps = {
  data: DailySummaryDatum[]
  title: string
  description: string
}

export function DailySummaryChart({
  data,
  title,
  description,
}: DailySummaryChartProps) {
  const { locale, t } = useI18n()

  return (
    <Card>
      <CardHeader className="pb-2">
        <CardTitle className="text-base">{title}</CardTitle>
        <CardDescription>{description}</CardDescription>
      </CardHeader>
      <CardContent className="pt-0">
        {data.length === 0 ? (
          <ListEmptyState
            icon={CalendarRange}
            title={t('statistics.daily.emptyTitle')}
            description={t('statistics.daily.emptyDescription')}
          />
        ) : (
          <div className="h-72 w-full min-w-0" dir="ltr">
            <ResponsiveContainer width="100%" height="100%">
              <LineChart
                data={data}
                margin={{ top: 8, right: 8, left: 0, bottom: 8 }}
              >
                <CartesianGrid strokeDasharray="3 3" stroke="var(--border)" />
                <XAxis
                  dataKey="date"
                  tick={{ fontSize: 11, fill: 'var(--muted-foreground)' }}
                  tickFormatter={(v) => formatDateShort(String(v), locale)}
                  minTickGap={16}
                />
                <YAxis
                  tick={{ fontSize: 11, fill: 'var(--muted-foreground)' }}
                  width={44}
                  allowDecimals={false}
                  tickFormatter={(v) => formatNumber(Number(v))}
                />
                <Tooltip
                  contentStyle={{
                    background: 'var(--popover)',
                    border: '1px solid var(--border)',
                    borderRadius: '8px',
                    fontSize: '12px',
                  }}
                  formatter={(value) => formatNumber(Number(value ?? 0))}
                  labelFormatter={(label) =>
                    formatDateShort(String(label), locale)
                  }
                />
                <Legend wrapperStyle={{ fontSize: '12px' }} />
                <Line
                  type="monotone"
                  dataKey="rides"
                  name={t('statistics.daily.rides')}
                  stroke="var(--primary)"
                  strokeWidth={2}
                  dot={false}
                />
                <Line
                  type="monotone"
                  dataKey="reservations"
                  name={t('statistics.daily.reservations')}
                  stroke="var(--chart-2, #10b981)"
                  strokeWidth={2}
                  dot={false}
                />
              </LineChart>
            </ResponsiveContainer>
          </div>
        )}
      </CardContent>
    </Card>
  )
}
