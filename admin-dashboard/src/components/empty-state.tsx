import type { LucideIcon } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { cn } from '@/lib/utils'

type ListEmptyStateProps = {
  icon: LucideIcon
  title: string
  description: string
  actionLabel?: string
  onAction?: () => void
  className?: string
}

export function ListEmptyState({
  icon: Icon,
  title,
  description,
  actionLabel,
  onAction,
  className,
}: ListEmptyStateProps) {
  return (
    <div
      className={cn(
        'flex flex-col items-center justify-center gap-4 rounded-lg border border-dashed bg-muted/20 px-6 py-14 text-center',
        className,
      )}
    >
      <div className="bg-muted/60 text-muted-foreground flex size-16 items-center justify-center rounded-2xl">
        <Icon className="size-8 stroke-[1.25]" aria-hidden />
      </div>
      <div className="max-w-sm space-y-1">
        <p className="text-foreground font-medium">{title}</p>
        <p className="text-muted-foreground text-sm">{description}</p>
      </div>
      {actionLabel && onAction ? (
        <Button type="button" variant="secondary" onClick={onAction}>
          {actionLabel}
        </Button>
      ) : null}
    </div>
  )
}
