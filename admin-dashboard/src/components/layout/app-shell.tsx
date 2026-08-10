import { useEffect } from 'react'
import { Outlet, useLocation, useNavigate } from 'react-router-dom'
import { ChevronDown, LogOut, Moon, Sun, User } from 'lucide-react'
import { SidebarInset, SidebarProvider, SidebarTrigger } from '@/components/ui/sidebar'
import { Button, buttonVariants } from '@/components/ui/button'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { AppBreadcrumbs } from '@/components/layout/app-breadcrumbs'
import { AppSidebar } from '@/components/layout/app-sidebar'
import { useThemeStore } from '@/stores/theme-store'
import { TooltipProvider } from '@/components/ui/tooltip'
import { useAuth } from '@/contexts/auth-context'
import { useI18n } from '@/contexts/i18n'
import { cn } from '@/lib/utils'
import { RouteErrorBoundary } from '@/components/route-error-boundary'

export function AppShell() {
  const navigate = useNavigate()
  const { pathname } = useLocation()
  const { user, signOut } = useAuth()
  const theme = useThemeStore((s) => s.theme)
  const toggleTheme = useThemeStore((s) => s.toggle)
  const { locale, setLocale, t } = useI18n()

  async function handleSignOut() {
    await signOut()
    navigate('/sign-in', { replace: true })
  }

  useEffect(() => {
    document.documentElement.classList.toggle('dark', theme === 'dark')
  }, [theme])

  return (
    <TooltipProvider>
      <SidebarProvider>
        <AppSidebar />
        <SidebarInset>
          <header className="bg-background sticky top-0 z-10 flex h-14 shrink-0 items-center gap-2 border-b border-s px-4">
            <SidebarTrigger className="ltr:-ml-1 rtl:-mr-1" />
            <div className="flex flex-1 items-center justify-between gap-2">
              <AppBreadcrumbs />
              <div className="flex items-center gap-2">
                <DropdownMenu>
                  <DropdownMenuTrigger
                    className={cn(
                      buttonVariants({ variant: 'outline', size: 'sm' }),
                      'h-8 max-w-[min(100%,14rem)] gap-1.5 px-2 text-xs',
                    )}
                    aria-label={t('userMenu.openMenu')}
                  >
                    <User className="size-3.5 shrink-0 opacity-80" />
                    <span className="truncate">
                      {user?.displayName ?? '—'}
                    </span>
                    <ChevronDown className="size-3.5 shrink-0 opacity-60" />
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="end" className="min-w-56">
                    <DropdownMenuGroup>
                      <DropdownMenuLabel className="font-normal">
                        <div className="flex flex-col gap-0.5 py-0.5">
                          <span className="text-sm font-medium text-foreground">
                            {user?.displayName}
                          </span>
                          {user?.email ? (
                            <span className="text-xs text-muted-foreground break-all">
                              {user.email}
                            </span>
                          ) : null}
                        </div>
                      </DropdownMenuLabel>
                    </DropdownMenuGroup>
                    <DropdownMenuSeparator />
                    <DropdownMenuGroup>
                      <DropdownMenuItem
                        variant="destructive"
                        onClick={() => handleSignOut()}
                      >
                        <LogOut className="size-4" />
                        {t('userMenu.signOut')}
                      </DropdownMenuItem>
                    </DropdownMenuGroup>
                  </DropdownMenuContent>
                </DropdownMenu>
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  className="h-8 px-2 text-xs"
                  onClick={() => setLocale(locale === 'en' ? 'ar' : 'en')}
                  aria-label={t('app.toggleLocale')}
                >
                  {locale === 'en' ? t('app.locale.ar') : t('app.locale.en')}
                </Button>
                <Button
                  type="button"
                  variant="outline"
                  size="icon"
                  className="size-8"
                  onClick={() => toggleTheme()}
                  aria-label={t('app.toggleTheme')}
                >
                  {theme === 'dark' ? (
                    <Sun className="size-4" />
                  ) : (
                    <Moon className="size-4" />
                  )}
                </Button>
              </div>
            </div>
          </header>
          <main className="flex-1 overflow-auto p-4 md:p-6">
            <RouteErrorBoundary key={pathname}>
              <Outlet />
            </RouteErrorBoundary>
          </main>
        </SidebarInset>
      </SidebarProvider>
    </TooltipProvider>
  )
}
