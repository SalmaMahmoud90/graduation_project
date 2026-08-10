import { Button } from '@/components/ui/button'
import { useI18n } from '@/contexts/i18n'
import { cn } from '@/lib/utils'

const PAGE_SIZES = [10, 25, 50] as const

type TablePaginationProps = {
  page: number
  pageSize: number
  total: number
  totalPages: number
  onPageChange: (page: number) => void
  onPageSizeChange: (size: number) => void
  className?: string
}

export function TablePagination({
  page,
  pageSize,
  total,
  totalPages,
  onPageChange,
  onPageSizeChange,
  className,
}: TablePaginationProps) {
  const { t } = useI18n()
  const from = total === 0 ? 0 : (page - 1) * pageSize + 1
  const to = Math.min(page * pageSize, total)

  return (
    <div
      className={cn(
        'flex flex-col gap-3 border-t px-2 py-3 sm:flex-row sm:items-center sm:justify-between',
        className,
      )}
    >
      <div className="flex flex-wrap items-center gap-3 text-muted-foreground text-sm">
        <span>
          {t('pagination.showing', { from, to, total })}
        </span>
        <label className="inline-flex items-center gap-2">
          <span className="sr-only">{t('pagination.pageSize')}</span>
          <select
            className="border-input bg-background h-8 rounded-md border px-2 text-foreground text-sm"
            value={pageSize}
            onChange={(e) => onPageSizeChange(Number(e.target.value))}
            aria-label={t('pagination.pageSize')}
          >
            {PAGE_SIZES.map((n) => (
              <option key={n} value={n}>
                {t('pagination.perPage', { n })}
              </option>
            ))}
          </select>
        </label>
      </div>
      <div className="flex items-center gap-2">
        <Button
          type="button"
          size="sm"
          variant="outline"
          disabled={page <= 1}
          onClick={() => onPageChange(page - 1)}
        >
          {t('pagination.prev')}
        </Button>
        <span className="text-muted-foreground tabular-nums text-sm px-1">
          {t('pagination.pageOf', { page, totalPages })}
        </span>
        <Button
          type="button"
          size="sm"
          variant="outline"
          disabled={page >= totalPages}
          onClick={() => onPageChange(page + 1)}
        >
          {t('pagination.next')}
        </Button>
      </div>
    </div>
  )
}
