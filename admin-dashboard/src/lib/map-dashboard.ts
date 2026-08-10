import type {
  ApiDepositRequestRow,
  ApiReportRow,
  ApiReservationRow,
  ApiRideRow,
  ApiTransaction,
  ApiUserRow,
} from '@/api/types-api'
import type {
  Booking,
  DepositRequest,
  DepositStatus,
  Report,
  ReportStatus,
  Ride,
  Transaction,
  User,
} from '@/types/domain'

function toNumber(value: string | number | null | undefined): number {
  if (value == null) return 0
  const n = typeof value === 'string' ? parseFloat(value) : value
  return Number.isFinite(n) ? n : 0
}

export function mapApiUser(u: ApiUserRow): User {
  const role: User['role'] =
    u.user_type === 'rider'
      ? 'passenger'
      : u.user_type === 'driver'
        ? 'driver'
        : 'admin'
  const email = u.email?.trim() ?? ''
  const display = u.name?.trim() || email || `Member #${u.id}`
  const banned = u.is_active === false
  return {
    id: String(u.id),
    email,
    fullName: display,
    role,
    status: banned ? 'banned' : 'active',
    createdAt: u.created_at,
    reportsCount: u.reports_count ?? 0,
    balance: u.balance == null ? undefined : toNumber(u.balance),
  }
}

export function mapApiTransaction(txn: ApiTransaction): Transaction {
  return {
    id: String(txn.id),
    amount: toNumber(txn.amount),
    type: txn.transaction_type,
    createdAt: txn.created_at,
  }
}

export function mapApiReport(r: ApiReportRow): Report {
  const statusMap: Record<string, ReportStatus> = {
    pending: 'pending',
    reviewed: 'reviewed',
  }
  return {
    id: String(r.id),
    reporterId: r.reporter == null ? '' : String(r.reporter),
    reportedUserId: r.reported_user == null ? '' : String(r.reported_user),
    rideId: r.ride == null ? '' : String(r.ride),
    type: r.type,
    reason: r.reason,
    status: statusMap[r.status] ?? 'pending',
    adminNote: r.admin_note ?? '',
    createdAt: r.created_at,
    updatedAt: r.updated_at,
  }
}

export function mapApiDepositRequest(d: ApiDepositRequestRow): DepositRequest {
  const amount = typeof d.amount === 'string' ? parseFloat(d.amount) : d.amount
  const statusMap: Record<string, DepositStatus> = {
    pending: 'pending',
    approved: 'approved',
    rejected: 'rejected',
  }
  return {
    id: String(d.id),
    userName: d.user_name?.trim() || `#${d.id}`,
    paymentMethod: d.payment_method,
    amount: Number.isFinite(amount) ? amount : 0,
    status: statusMap[d.status] ?? 'pending',
    createdAt: d.created_at,
    transactionReference:
      'transaction_reference' in d
        ? (d as { transaction_reference?: string }).transaction_reference
        : undefined,
  }
}

function normalizeRideStatus(raw: string): Ride['status'] {
  if (raw === 'active' || raw === 'completed' || raw === 'cancelled')
    return raw
  return 'active'
}

/**
 * The API now returns a separate `departure_date` (calendar date) and
 * `departure_time` (time of day). Combine them into a single value for display
 * and sorting, falling back to whichever part is present.
 */
function combineDeparture(
  date: string | null | undefined,
  time: string | null | undefined,
): string {
  if (date && time) return `${date}T${time}`
  return date || time || ''
}

export function mapApiRide(r: ApiRideRow): Ride {
  const cost = typeof r.cost === 'string' ? parseFloat(r.cost) : r.cost
  const taken = Math.max(0, r.capacity - r.available_seats)
  const statusNorm = normalizeRideStatus(String(r.status))
  const driverName = r.driver_name ?? r.driver_info?.driver_name ?? ''
  return {
    id: String(r.id),
    driverName,
    origin: r.location,
    destination: r.destination,
    departureAt: combineDeparture(r.departure_date, r.departure_time),
    expectedDuration: r.expected_duration ?? '',
    seatsTotal: r.capacity,
    seatsTaken: taken,
    fareShare: Number.isFinite(cost) ? cost : 0,
    currency: '',
    status: statusNorm,
  }
}

export function mapApiReservation(r: ApiReservationRow): Booking {
  const statusMap: Record<string, Booking['status']> = {
    pending: 'pending',
    accepted: 'confirmed',
    rejected: 'rejected',
  }
  const payment: Booking['payment'] = r.payment === 'paid' ? 'paid' : 'unpaid'
  const rideLocation = 'ride_location' in r ? (r as any).ride_location : undefined
  const rideDestination = 'ride_destination' in r ? (r as any).ride_destination : undefined
  return {
    id: String(r.id),
    rideId: r.ride == null ? '' : String(r.ride),
    passengerId: '',
    passengerName: r.rider_name,
    status: statusMap[r.status] ?? 'pending',
    payment,
    createdAt: r.created_at,
    rideLocation,
    rideDestination,
  }
}
