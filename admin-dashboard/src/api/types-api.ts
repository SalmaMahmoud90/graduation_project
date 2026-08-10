export type ApiPaginatedResponse<T> = {
  next: string | null
  previous: string | null
  results: T[]
  count?: number
}

export type ApiUserRow = {
  id: number
  name: string | null
  user_type: 'driver' | 'rider' | 'admin' | null
  created_at: string
  /** Present on some deployments only */
  email?: string
  is_active?: boolean
  /** Number of reports filed against this user (from view_users/) */
  reports_count?: number
  /** Wallet balance (from view_users/ and the user profile) */
  balance?: string | number | null
}

export type ApiReportRow = {
  id: number
  reporter: number | null
  reported_user: number | null
  ride: number | null
  type: string
  reason: string
  status: string
  /** Admin's note on the report (from view_report_details/ and send_note/) */
  admin_note?: string | null
  created_at: string
  updated_at?: string
}

export type ApiDepositRequestRow = {
  id: number
  user_name: string | null
  payment_method: string
  amount: string | number
  status: string
  created_at: string
}

export type ApiDepositRequestDetail = ApiDepositRequestRow & {
  transaction_reference?: string
}

export type ApiRideRow = {
  id: number
  location: string
  destination: string
  /** Top-level on list endpoints; nested under driver_info on detail endpoints */
  driver_name?: string
  driver_info?: {
    driver_name?: string
    car_image?: string | null
  }
  departure_time: string | null
  departure_date?: string | null
  expected_duration?: string | null
  capacity: number
  available_seats: number
  cost: string | number
  status: string
}

export type ApiReservationRow = {
  id: number
  rider_name: string
  /** Absent on the user-detail reservation shape (ReservationDetailSerializer) */
  ride?: number
  status: string
  created_at: string
  payment?: string
}

export type ApiRideDetail = ApiRideRow & {
  available_seats: number
  reservations: ApiReservationRow[]
}

export type ApiUserDetailReservationRow = ApiReservationRow & {
  ride_location?: string
  ride_destination?: string
}

export type ApiTransaction = {
  id: number
  amount: string | number
  transaction_type: string
  created_at: string
}

/** Nested profile block returned by view_user_details/ (UserProfileSerializer). */
export type ApiUserProfile = {
  id: number
  user_type: 'driver' | 'rider' | 'admin' | null
  status?: string
  created_at?: string
  balance?: string | number | null
  transactions?: ApiTransaction[]
}

export type ApiUserDetail = {
  profile?: ApiUserProfile
  rides?: ApiRideRow[]
  reservations?: ApiUserDetailReservationRow[]
}

export type LoginResponse = {
  access_token: string
  token_type?: string
  expires_in?: number
  refresh_token?: string
  scope?: string
  user?: {
    email: string
    name: string | null
    user_type: string
  }
}
