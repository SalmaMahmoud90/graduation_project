export type UserRole = 'driver' | 'passenger' | 'admin'

export type UserStatus = 'active' | 'banned'

export interface User {
  id: string
  email: string
  fullName: string
  role: UserRole
  status: UserStatus
  phone?: string
  createdAt: string
  reportsCount: number
  /** Wallet balance, when the API exposes it (view_users / user profile). */
  balance?: number
}

export type TransactionType = 'deposit' | 'payment' | string

export interface Transaction {
  id: string
  amount: number
  type: TransactionType
  createdAt: string
}

export type RideStatus = 'active' | 'scheduled' | 'in_progress' | 'completed' | 'cancelled'

export interface Ride {
  id: string
  driverName: string
  origin: string
  destination: string
  /** Combined departure date + time of day (ISO-ish) for display/sorting. */
  departureAt: string
  /** Free-text expected trip duration (e.g. "2 hours"), when provided. */
  expectedDuration: string
  seatsTotal: number
  seatsTaken: number
  fareShare: number
  currency: string
  status: RideStatus
}

export type BookingStatus = 'pending' | 'confirmed' | 'rejected' | 'cancelled'

export type BookingPayment = 'paid' | 'unpaid'

export interface Booking {
  id: string
  rideId: string
  passengerId: string
  passengerName: string
  status: BookingStatus
  payment: BookingPayment
  createdAt: string
  rideLocation?: string
  rideDestination?: string
}

export interface DashboardStats {
  totalUsers: number
  activeUsers: number
  bannedUsers: number
  totalRides: number
  activeRides: number
  totalBookings: number
  pendingBookings: number
  driverAccounts: number
  passengerAccounts: number
  openReports: number
  pendingDepositRequests: number
}

export type ReportStatus = 'pending' | 'reviewed'

export interface Report {
  id: string
  reporterId: string
  reportedUserId: string
  rideId: string
  type: string
  reason: string
  status: ReportStatus
  adminNote: string
  createdAt: string
  updatedAt?: string
}

export type PaymentMethod = 'syriatel_cash' | 'mtn_cash' | 'sham_cash'

export type DepositStatus = 'pending' | 'approved' | 'rejected'

export interface DepositRequest {
  id: string
  userName: string
  paymentMethod: PaymentMethod | string
  amount: number
  status: DepositStatus
  createdAt: string
  transactionReference?: string
}
