import { NavLink, useLocation } from 'react-router-dom'
import {
  LayoutDashboard,
  BarChart3,
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
  { to: '/statistics', key: 'nav.statistics', icon: BarChart3 },
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
            width={80}
            className="invert dark:filter-none"
          />
         
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
