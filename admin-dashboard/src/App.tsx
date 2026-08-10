import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom'
import { AppShell } from '@/components/layout/app-shell'
import { useAuth } from '@/contexts/auth-context'
import { BookingsPage } from '@/pages/bookings-page'
import { DashboardPage } from '@/pages/dashboard-page'
import { DepositRequestsPage } from '@/pages/deposit-requests-page'
import { ReportsPage } from '@/pages/reports-page'
import { RideDetailPage } from '@/pages/ride-detail-page'
import { RidesPage } from '@/pages/rides-page'
import { SignInPage } from '@/pages/sign-in-page'
import { UserDetailPage } from '@/pages/user-detail-page'
import { UsersPage } from '@/pages/users-page'

export default function App() {
  const { isAuthenticated } = useAuth()

  return (
    <BrowserRouter>
      <Routes>
        <Route
          path="sign-in"
          element={
            isAuthenticated ? <Navigate to="/" replace /> : <SignInPage />
          }
        />
        <Route
          element={
            isAuthenticated ? <AppShell /> : <Navigate to="/sign-in" replace />
          }
        >
          <Route index element={<DashboardPage />} />
          <Route path="users" element={<UsersPage />} />
          <Route path="users/:userId" element={<UserDetailPage />} />
          <Route path="rides" element={<RidesPage />} />
          <Route path="rides/:rideId" element={<RideDetailPage />} />
          <Route path="bookings" element={<BookingsPage />} />
          <Route path="deposit-requests" element={<DepositRequestsPage />} />
          <Route path="reports" element={<ReportsPage />} />
        </Route>
        <Route
          path="*"
          element={
            <Navigate to={isAuthenticated ? '/' : '/sign-in'} replace />
          }
        />
      </Routes>
    </BrowserRouter>
  )
}
