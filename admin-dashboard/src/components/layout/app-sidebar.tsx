import { NavLink, useLocation } from 'react-router-dom'
import {
  LayoutDashboard,
  Users,
  Car,
  ClipboardList,
  Wallet,
  Flag,
} from 'lucide-react'
import {
  Sidebar,
  SidebarContent,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarRail,
} from '@/components/ui/sidebar'
import { useI18n } from '@/contexts/i18n'
import { BRAND_LOGO_SRC, BRAND_NAME } from '@/lib/brand'

const nav = [
  { to: '/', key: 'nav.overview', icon: LayoutDashboard, end: true },
  { to: '/users', key: 'nav.users', icon: Users },
  { to: '/rides', key: 'nav.rides', icon: Car },
  { to: '/bookings', key: 'nav.bookings', icon: ClipboardList },
  { to: '/deposit-requests', key: 'nav.deposits', icon: Wallet },
  { to: '/reports', key: 'nav.reports', icon: Flag },
]

function routeIsActive(pathname: string, to: string, end?: boolean) {
  if (end) return pathname === to
  if (to === '/') return pathname === '/'
  return pathname === to || pathname.startsWith(`${to}/`)
}

export function AppSidebar() {
  const { pathname } = useLocation()
  const { locale, t } = useI18n()

  return (
    <Sidebar collapsible="icon" side={locale === 'ar' ? 'right' : 'left'}>
      <SidebarHeader className="h-14 justify-center border-b border-sidebar-border px-3 py-0">
        <div className="flex items-center gap-3 group-data-[collapsible=icon]:justify-center">
          <img
            src={BRAND_LOGO_SRC}
            alt={BRAND_NAME}
            width={40}
            height={40}
            className="size-10 shrink-0 rounded-full object-cover ring-1 ring-primary/25"
          />
          <div className="flex min-w-0 flex-col gap-0.5 leading-tight group-data-[collapsible=icon]:hidden">
            <span className="text-sm font-semibold tracking-tight">
              {t('sidebar.brand')}
            </span>
            <span className="text-muted-foreground text-xs">
              {t('sidebar.subtitle')}
            </span>
          </div>
        </div>
      </SidebarHeader>
      <SidebarContent>
        <SidebarGroup>
          <SidebarGroupLabel>{t('sidebar.navigate')}</SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu>
              {nav.map((item) => (
                <SidebarMenuItem key={item.to}>
                  <SidebarMenuButton
                    tooltip={t(item.key)}
                    isActive={routeIsActive(pathname, item.to, item.end)}
                    render={
                      <NavLink to={item.to} end={item.end}>
                        <item.icon className="size-4 shrink-0" />
                        <span>{t(item.key)}</span>
                      </NavLink>
                    }
                  />
                </SidebarMenuItem>
              ))}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>
      </SidebarContent>
      <SidebarRail />
    </Sidebar>
  )
}
