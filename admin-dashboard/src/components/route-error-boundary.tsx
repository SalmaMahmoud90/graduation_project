import { Component, type ErrorInfo, type ReactNode } from 'react'
import { Button } from '@/components/ui/button'
import { useI18n } from '@/contexts/i18n'

type Props = { children: ReactNode }

type State = { error: Error | null }

function RouteErrorFallback({
  error,
  onRetry,
}: {
  error: Error
  onRetry: () => void
}) {
  const { t } = useI18n()
  const details = [error.message, error.stack].filter(Boolean).join('\n\n')

  async function copyDetails() {
    try {
      await navigator.clipboard.writeText(details || error.message)
    } catch {
      return
    }
  }

  return (
    <div className="mx-auto flex max-w-lg flex-col gap-4 rounded-xl border bg-card p-6 shadow-sm">
      <div className="space-y-1">
        <h2 className="text-lg font-semibold tracking-tight">
          {t('errorBoundary.title')}
        </h2>
        <p className="text-muted-foreground text-sm">
          {t('errorBoundary.description')}
        </p>
      </div>
      <pre className="bg-muted max-h-40 overflow-auto rounded-md p-3 text-xs whitespace-pre-wrap break-all">
        {error.message}
      </pre>
      <div className="flex flex-wrap gap-2">
        <Button type="button" onClick={onRetry}>
          {t('errorBoundary.retry')}
        </Button>
        <Button type="button" variant="outline" onClick={() => void copyDetails()}>
          {t('errorBoundary.copy')}
        </Button>
      </div>
    </div>
  )
}

export class RouteErrorBoundary extends Component<Props, State> {
  state: State = { error: null }

  static getDerivedStateFromError(error: Error): State {
    return { error }
  }

  componentDidCatch(error: Error, info: ErrorInfo) {
    console.error('Route error boundary:', error, info.componentStack)
  }

  render() {
    if (this.state.error) {
      return (
        <RouteErrorFallback
          error={this.state.error}
          onRetry={() => this.setState({ error: null })}
        />
      )
    }
    return this.props.children
  }
}
