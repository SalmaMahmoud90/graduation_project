import {
  Bar,
  BarChart,
  CartesianGrid,
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
import { formatNumber } from '@/lib/format'
import { useI18n } from '@/contexts/i18n'

export type OverviewChartDatum = { name: string; value: number }

type DashboardOverviewChartProps = {
  data: OverviewChartDatum[]
  title: string
  description: string
}

export function DashboardOverviewChart({
  data,
  title,
  description,
}: DashboardOverviewChartProps) {
  const { locale, t } = useI18n()

  return (
    <Card>
      <CardHeader className="pb-2">
        <CardTitle className="text-base">{title}</CardTitle>
        <CardDescription>{description}</CardDescription>
      </CardHeader>
      <CardContent className="pt-0">
        <div className="h-72 w-full min-w-0" dir="ltr">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart
              data={data}
              margin={{ top: 8, right: 8, left: 0, bottom: locale === 'ar' ? 8 : 48 }}
            >
              <CartesianGrid strokeDasharray="3 3" stroke="var(--border)" />
              <XAxis
                dataKey="name"
                tick={{ fontSize: 10, fill: 'var(--muted-foreground)' }}
                interval={0}
                angle={locale === 'ar' ? 0 : -32}
                textAnchor={locale === 'ar' ? 'middle' : 'end'}
                height={locale === 'ar' ? 56 : 72}
              />
              <YAxis
                tick={{ fontSize: 11, fill: 'var(--muted-foreground)' }}
                width={44}
                tickFormatter={(v) => formatNumber(Number(v))}
              />
              <Tooltip
                contentStyle={{
                  background: 'var(--popover)',
                  border: '1px solid var(--border)',
                  borderRadius: '8px',
                  fontSize: '12px',
                }}
                formatter={(value) => [
                  formatNumber(Number(value ?? 0)),
                  t('dashboard.chart.valueLabel'),
                ]}
                labelFormatter={(label) => String(label)}
              />
              <Bar
                dataKey="value"
                name={t('dashboard.chart.valueLabel')}
                fill="var(--primary)"
                radius={[4, 4, 0, 0]}
                maxBarSize={48}
              />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </CardContent>
    </Card>
  )
}
