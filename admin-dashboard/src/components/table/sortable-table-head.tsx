import { ArrowDown, ArrowUp, ArrowUpDown } from 'lucide-react'
import { TableHead } from '@/components/ui/table'
import { cn } from '@/lib/utils'
import type { SortDir } from '@/lib/client-table'

type SortableTableHeadProps = {
  label: string
  sortKey: string
  activeKey: string
  dir: SortDir
  onSort: (key: string) => void
  className?: string
}

export function SortableTableHead({
  label,
  sortKey,
  activeKey,
  dir,
  onSort,
  className,
}: SortableTableHeadProps) {
  const active = activeKey === sortKey
  return (
    <TableHead className={className}>
      <button
        type="button"
        className={cn(
          '-mx-1 inline-flex items-center gap-1 rounded-sm px-1 py-0.5 font-medium hover:bg-muted/80 hover:text-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring',
        )}
        onClick={() => onSort(sortKey)}
      >
        <span>{label}</span>
        {active ? (
          dir === 'asc' ? (
            <ArrowUp className="size-3.5 shrink-0 opacity-80" aria-hidden />
          ) : (
            <ArrowDown className="size-3.5 shrink-0 opacity-80" aria-hidden />
          )
        ) : (
          <ArrowUpDown className="size-3.5 shrink-0 opacity-35" aria-hidden />
        )}
      </button>
    </TableHead>
  )
}
