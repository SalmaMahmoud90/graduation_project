import type { ApiRideRow } from '@/api/types-api'
import { formatRouteLabel } from '@/lib/format'

type RideLabelSource = ApiRideRow | { id: string; origin: string; destination: string }

/** Label from dashboard ride rows or mapped ride objects. */
export function rideRouteLabel(
  rideId: string,
  rides: RideLabelSource[],
  locale: string | undefined,
): string {
  const r = rides.find((x) => String(x.id) === rideId)
  if (!r) return '—'
  const origin = 'location' in r ? r.location : r.origin
  const destination = r.destination
  return formatRouteLabel(origin, destination, locale)
}

/** Path to ride detail; optional query hints when origin/destination are known. */
export function rideDetailPath(
  rideId: string,
  origin?: string,
  destination?: string,
): string {
  const base = `/rides/${rideId}`
  const o = origin?.trim()
  const d = destination?.trim()
  if (!o || !d) return base
  const q = new URLSearchParams({ location: o, destination: d })
  return `${base}?${q.toString()}`
}
