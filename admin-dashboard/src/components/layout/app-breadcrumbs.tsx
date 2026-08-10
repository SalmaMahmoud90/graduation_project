import { Link, useLocation } from 'react-router-dom'
import { ChevronRight } from 'lucide-react'
import { useI18n } from '@/contexts/i18n'

const pathToNavKey: Record<string, string> = {
  '/': 'nav.overview',
  '/users': 'nav.users',
  '/rides': 'nav.rides',
  '/bookings': 'nav.bookings',
  '/reports': 'nav.reports',
}

export function AppBreadcrumbs() {
  const { pathname } = useLocation()
  const { t } = useI18n()

  const normalized =
    pathname.length > 1 && pathname.endsWith('/')
      ? pathname.slice(0, -1)
      : pathname

  const rideDetailMatch = /^\/rides\/(\d+)$/.exec(normalized)
  const userDetailMatch = /^\/users\/(\d+)$/.exec(normalized)

  if (userDetailMatch) {
    const id = userDetailMatch[1]
    return (
      <nav aria-label={t('breadcrumb.label')} className="min-w-0 flex-1">
        <ol className="flex flex-wrap items-center gap-x-1.5 gap-y-1 text-sm">
          <li className="inline-flex min-w-0 items-center">
            <Link
              to="/"
              className="text-muted-foreground truncate transition-colors hover:text-foreground"
            >
              {t('app.title')}
            </Link>
          </li>
          <li aria-hidden className="flex shrink-0 text-muted-foreground/50">
            <ChevronRight className="size-3.5 rtl:rotate-180" />
          </li>
          <li className="inline-flex min-w-0 items-center">
            <Link
              to="/users"
              className="text-muted-foreground truncate transition-colors hover:text-foreground"
            >
              {t('nav.users')}
            </Link>
          </li>
          <li aria-hidden className="flex shrink-0 text-muted-foreground/50">
            <ChevronRight className="size-3.5 rtl:rotate-180" />
          </li>
          <li
            className="min-w-0 truncate font-medium text-foreground"
            aria-current="page"
          >
            {t('users.detail.breadcrumb', { id })}
          </li>
        </ol>
      </nav>
    )
  }

  if (rideDetailMatch) {
    const id = rideDetailMatch[1]
    return (
      <nav aria-label={t('breadcrumb.label')} className="min-w-0 flex-1">
        <ol className="flex flex-wrap items-center gap-x-1.5 gap-y-1 text-sm">
          <li className="inline-flex min-w-0 items-center">
            <Link
              to="/"
              className="text-muted-foreground truncate transition-colors hover:text-foreground"
            >
              {t('app.title')}
            </Link>
          </li>
          <li aria-hidden className="flex shrink-0 text-muted-foreground/50">
            <ChevronRight className="size-3.5 rtl:rotate-180" />
          </li>
          <li className="inline-flex min-w-0 items-center">
            <Link
              to="/rides"
              className="text-muted-foreground truncate transition-colors hover:text-foreground"
            >
              {t('nav.rides')}
            </Link>
          </li>
          <li aria-hidden className="flex shrink-0 text-muted-foreground/50">
            <ChevronRight className="size-3.5 rtl:rotate-180" />
          </li>
          <li
            className="min-w-0 truncate font-medium text-foreground"
            aria-current="page"
          >
            {t('rides.detail.breadcrumb', { id })}
          </li>
        </ol>
      </nav>
    )
  }

  const pageKey = pathToNavKey[normalized] ?? 'nav.overview'

  return (
    <nav aria-label={t('breadcrumb.label')} className="min-w-0 flex-1">
      <ol className="flex flex-wrap items-center gap-x-1.5 gap-y-1 text-sm">
        <li className="inline-flex min-w-0 items-center">
          <Link
            to="/"
            className="text-muted-foreground truncate transition-colors hover:text-foreground"
          >
            {t('app.title')}
          </Link>
        </li>
        <li aria-hidden className="flex shrink-0 text-muted-foreground/50">
          <ChevronRight className="size-3.5 rtl:rotate-180" />
        </li>
        <li
          className="min-w-0 truncate font-medium text-foreground"
          aria-current="page"
        >
          {t(pageKey)}
        </li>
      </ol>
    </nav>
  )
}
