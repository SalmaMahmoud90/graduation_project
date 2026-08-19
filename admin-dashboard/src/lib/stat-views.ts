import type { LucideIcon } from 'lucide-react'
import {
  AlertTriangle,
  Car,
  Database,
  Flag,
  Gauge,
  LayoutDashboard,
  LocateFixed,
  MapPin,
  ScrollText,
  TrendingUp,
  UserRound,
  UsersRound,
  UserX,
  Wallet,
  Wifi,
} from 'lucide-react'
import type { Locale } from '@/i18n/translations'

/**
 * How a given report should be rendered:
 * - `kpi`   — one row of headline numbers, shown as stat cards.
 * - `bar`   — a labelled category count, shown as a bar chart (+ table).
 * - `table` — a list of records, shown as a data table.
 */
export type StatViewKind = 'kpi' | 'bar' | 'table'

export type StatCategory =
  | 'overview'
  | 'rides'
  | 'users'
  | 'financial'
  | 'monitoring'
  | 'location'

/** How a raw id/email column is turned into a human name (+ link). */
export type ResolveKind = 'userById' | 'userByEmail' | 'rideById'

type Localized = Record<Locale, string>

export type StatViewConfig = {
  /** Matches the backend whitelist key. */
  key: string
  category: StatCategory
  icon: LucideIcon
  kind: StatViewKind
  /** For `bar` reports: which column is the label and which is the value. */
  bar?: { labelKey: string; valueKey: string }
  /** Columns that hold a user/ride reference to resolve into a name + link. */
  resolve?: Record<string, ResolveKind>
  /** Raw columns (e.g. internal ids) to drop from the table entirely. */
  hide?: string[]
  label: Localized
  description: Localized
}

/** Category display order + labels for the reports menu. */
export const STAT_CATEGORIES: { key: StatCategory; label: Localized }[] = [
  { key: 'overview', label: { en: 'Overview', ar: 'نظرة عامة' } },
  {
    key: 'rides',
    label: { en: 'Rides & reservations', ar: 'الرحلات والحجوزات' },
  },
  { key: 'users', label: { en: 'Members', ar: 'الأعضاء' } },
  { key: 'financial', label: { en: 'Financial', ar: 'المالية' } },
  { key: 'monitoring', label: { en: 'Activity', ar: 'النشاط' } },
  { key: 'location', label: { en: 'Location', ar: 'الموقع' } },
]

export const STAT_VIEWS: StatViewConfig[] = [
  {
    key: 'view_admin_dashboard_summary',
    category: 'overview',
    icon: LayoutDashboard,
    kind: 'kpi',
    label: { en: 'Platform summary', ar: 'ملخص المنصة' },
    description: {
      en: 'Live totals: active members, active rides, open reports, wallet balance, and 30-day revenue.',
      ar: 'إجماليات لحظية: الأعضاء النشطون، الرحلات النشطة، البلاغات المفتوحة، رصيد المحافظ، وإيراد آخر ٣٠ يومًا.',
    },
  },
  {
    key: 'view_active_sessions_count',
    category: 'overview',
    icon: Wifi,
    kind: 'kpi',
    label: { en: 'Active sessions', ar: 'الجلسات النشطة' },
    description: {
      en: 'How many members are signed in right now.',
      ar: 'عدد الأعضاء المسجّلين دخولًا حاليًا.',
    },
  },
  {
    key: 'view_driver_trips_count',
    category: 'rides',
    icon: Car,
    kind: 'table',
    resolve: { driver_email: 'userByEmail' },
    hide: ['driver_id'],
    label: { en: 'Driver trips', ar: 'رحلات السائقين' },
    description: {
      en: 'Total rides published by each driver.',
      ar: 'إجمالي الرحلات المنشورة لكل سائق.',
    },
  },
  {
    key: 'view_most_active_riders',
    category: 'rides',
    icon: UserRound,
    kind: 'table',
    resolve: { rider_email: 'userByEmail' },
    hide: ['rider_id'],
    label: { en: 'Most active riders', ar: 'أنشط الركاب' },
    description: {
      en: 'Riders ranked by total reservations.',
      ar: 'الركاب مرتبين حسب إجمالي الحجوزات.',
    },
  },
  {
    key: 'view_popular_destinations',
    category: 'rides',
    icon: TrendingUp,
    kind: 'bar',
    bar: { labelKey: 'destination_city', valueKey: 'total_trips_to_destination' },
    label: { en: 'Popular destinations', ar: 'الوجهات الأكثر شيوعًا' },
    description: {
      en: 'Most requested destination cities.',
      ar: 'أكثر مدن الوجهة طلبًا.',
    },
  },
  {
    key: 'view_popular_pickup_locations',
    category: 'rides',
    icon: MapPin,
    kind: 'bar',
    bar: { labelKey: 'student_pickup_point', valueKey: 'total_requests' },
    label: { en: 'Popular pickup points', ar: 'نقاط الانطلاق الأكثر شيوعًا' },
    description: {
      en: 'Most requested pickup locations.',
      ar: 'أكثر نقاط الالتقاط طلبًا.',
    },
  },
  {
    key: 'view_ride_occupancy_rate',
    category: 'rides',
    icon: Gauge,
    kind: 'table',
    resolve: { ride_id: 'rideById' },
    label: { en: 'Ride occupancy', ar: 'إشغال الرحلات' },
    description: {
      en: 'Accepted reservations vs. seats for each ride.',
      ar: 'الحجوزات المقبولة مقابل المقاعد لكل رحلة.',
    },
  },
  {
    key: 'view_user_role_summary',
    category: 'users',
    icon: UsersRound,
    kind: 'table',
    label: { en: 'Members by role', ar: 'الأعضاء حسب الدور' },
    description: {
      en: 'Active / inactive member counts per role.',
      ar: 'أعداد الأعضاء النشطين وغير النشطين لكل دور.',
    },
  },
  {
    key: 'view_inactive_users',
    category: 'users',
    icon: UserX,
    kind: 'table',
    resolve: { id: 'userById' },
    label: { en: 'Inactive members', ar: 'الأعضاء الخاملون' },
    description: {
      en: 'Members with no sign-in in the last 90 days.',
      ar: 'أعضاء لم يسجّلوا دخولًا خلال آخر ٩٠ يومًا.',
    },
  },
  {
    key: 'view_most_reported_users',
    category: 'users',
    icon: Flag,
    kind: 'table',
    resolve: { reported_user_id: 'userById' },
    label: { en: 'Most reported members', ar: 'الأكثر تعرضًا للبلاغات' },
    description: {
      en: 'Members ranked by number of reports filed against them.',
      ar: 'الأعضاء مرتبين حسب عدد البلاغات ضدهم.',
    },
  },
  {
    key: 'view_wallet_summary',
    category: 'financial',
    icon: Wallet,
    kind: 'table',
    resolve: { user_id: 'userById' },
    hide: ['wallet_id'],
    label: { en: 'Wallet summary', ar: 'ملخص المحافظ' },
    description: {
      en: 'Balance, total deposits, and total spent for each member.',
      ar: 'الرصيد وإجمالي الإيداعات والمصروفات لكل عضو.',
    },
  },
  {
    key: 'view_suspicious_deposits',
    category: 'financial',
    icon: AlertTriangle,
    kind: 'table',
    resolve: { user_id: 'userById' },
    label: { en: 'Suspicious deposits', ar: 'الإيداعات المشبوهة' },
    description: {
      en: 'Members with more than 3 deposit requests within one hour.',
      ar: 'أعضاء بأكثر من ٣ طلبات إيداع خلال ساعة.',
    },
  },
  {
    key: 'view_audit_activity_by_day',
    category: 'monitoring',
    icon: ScrollText,
    kind: 'table',
    label: { en: 'Activity by day', ar: 'النشاط اليومي' },
    description: {
      en: 'How many changes happened in each area, day by day.',
      ar: 'عدد التغييرات في كل مجال، يومًا بيوم.',
    },
  },
  {
    key: 'view_last_known_location',
    category: 'location',
    icon: LocateFixed,
    kind: 'table',
    resolve: { user_id: 'userById' },
    label: { en: 'Last known locations', ar: 'آخر المواقع المعروفة' },
    description: {
      en: 'The latest recorded position for each member.',
      ar: 'أحدث موقع مسجّل لكل عضو.',
    },
  },
  {
    key: 'view_location_data_footprint',
    category: 'location',
    icon: Database,
    kind: 'table',
    resolve: { user_id: 'userById' },
    label: { en: 'Location history', ar: 'سجل المواقع' },
    description: {
      en: 'How many location updates each member has, and over what period.',
      ar: 'عدد تحديثات الموقع لكل عضو، وخلال أي فترة.',
    },
  },
]

export const STAT_VIEWS_BY_KEY: Record<string, StatViewConfig> =
  Object.fromEntries(STAT_VIEWS.map((v) => [v.key, v]))

/**
 * Business-friendly, bilingual headers for the raw columns each report returns.
 * Used for table headers and KPI card labels; unknown columns fall back to a
 * humanized version of the column name.
 */
export const COLUMN_LABELS: Record<string, Localized> = {
  // people / references (shown as resolved names)
  driver_email: { en: 'Driver', ar: 'السائق' },
  rider_email: { en: 'Rider', ar: 'الراكب' },
  id: { en: 'Member', ar: 'العضو' },
  user_id: { en: 'Member', ar: 'العضو' },
  reported_user_id: { en: 'Member', ar: 'العضو' },
  ride_id: { en: 'Ride', ar: 'الرحلة' },
  email: { en: 'Email', ar: 'البريد الإلكتروني' },
  user_type: { en: 'Role', ar: 'الدور' },
  // rides / reservations
  total_rides: { en: 'Trips', ar: 'الرحلات' },
  total_reservations: { en: 'Reservations', ar: 'الحجوزات' },
  destination_city: { en: 'Destination', ar: 'الوجهة' },
  total_trips_to_destination: { en: 'Trips', ar: 'الرحلات' },
  student_pickup_point: { en: 'Pickup point', ar: 'نقطة الانطلاق' },
  total_requests: { en: 'Requests', ar: 'الطلبات' },
  capacity: { en: 'Seats', ar: 'المقاعد' },
  accepted_reservations: { en: 'Booked', ar: 'المحجوزة' },
  occupancy_percent: { en: 'Occupancy', ar: 'نسبة الإشغال' },
  // members
  active_count: { en: 'Active', ar: 'نشط' },
  inactive_count: { en: 'Inactive', ar: 'غير نشط' },
  total_count: { en: 'Total', ar: 'الإجمالي' },
  last_login: { en: 'Last sign-in', ar: 'آخر دخول' },
  created_at: { en: 'Joined', ar: 'تاريخ الانضمام' },
  reports_count: { en: 'Reports', ar: 'البلاغات' },
  // financial
  balance: { en: 'Balance', ar: 'الرصيد' },
  total_deposits: { en: 'Total deposits', ar: 'إجمالي الإيداعات' },
  total_spent: { en: 'Total spent', ar: 'إجمالي المصروف' },
  hour_bucket: { en: 'Hour', ar: 'الساعة' },
  deposit_requests_count: { en: 'Deposit requests', ar: 'طلبات الإيداع' },
  // activity
  log_date: { en: 'Date', ar: 'التاريخ' },
  table_name: { en: 'Area', ar: 'المجال' },
  events_count: { en: 'Changes', ar: 'التغييرات' },
  active_sessions: { en: 'Active sessions', ar: 'الجلسات النشطة' },
  // location
  latitude: { en: 'Latitude', ar: 'خط العرض' },
  longitude: { en: 'Longitude', ar: 'خط الطول' },
  updated_at: { en: 'Updated', ar: 'آخر تحديث' },
  stored_points: { en: 'Recorded points', ar: 'النقاط المسجّلة' },
  earliest: { en: 'First seen', ar: 'أول ظهور' },
  latest: { en: 'Last seen', ar: 'آخر ظهور' },
  // overview KPIs
  active_users: { en: 'Active members', ar: 'الأعضاء النشطون' },
  active_rides: { en: 'Active rides', ar: 'الرحلات النشطة' },
  open_reports: { en: 'Open reports', ar: 'البلاغات المفتوحة' },
  total_wallet_balance: { en: 'Total balance', ar: 'إجمالي الأرصدة' },
  revenue_last_30_days: { en: 'Revenue (30 days)', ar: 'الإيراد (٣٠ يومًا)' },
}

/** Localized labels for `user_type` values (rider is shown as passenger). */
export const ROLE_LABELS: Record<string, Localized> = {
  driver: { en: 'Driver', ar: 'سائق' },
  rider: { en: 'Passenger', ar: 'راكب' },
  passenger: { en: 'Passenger', ar: 'راكب' },
  admin: { en: 'Supervisor', ar: 'مشرف' },
}

/** Business labels for the raw `table_name` values in the activity report. */
export const ACTIVITY_AREA_LABELS: Record<string, Localized> = {
  rides_ride: { en: 'Rides', ar: 'الرحلات' },
  rides_reservation: { en: 'Reservations', ar: 'الحجوزات' },
  users_mainuser: { en: 'Members', ar: 'الأعضاء' },
  payments_wallet: { en: 'Wallets', ar: 'المحافظ' },
  payments_transaction: { en: 'Transactions', ar: 'المعاملات' },
  payments_depositrequest: { en: 'Deposit requests', ar: 'طلبات الإيداع' },
  reports_report: { en: 'Reports', ar: 'البلاغات' },
}
