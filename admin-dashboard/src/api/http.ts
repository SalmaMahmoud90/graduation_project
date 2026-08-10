import { useAuthStore } from '@/stores/auth-store'

export class ApiError extends Error {
  status: number
  body?: unknown

  constructor(status: number, message: string, body?: unknown) {
    super(message)
    this.name = 'ApiError'
    this.status = status
    this.body = body
  }
}

/**
 * Empty string = same origin (use Vite dev proxy). Set `VITE_API_BASE_URL` only
 * if the app is served from a different host than the API.
 */
export function getApiBase() {
  const raw = import.meta.env.VITE_API_BASE_URL
  if (raw === undefined || String(raw).trim() === '') return ''
  return String(raw).replace(/\/$/, '')
}

/** Detects token/sign-in responses that mean the server isn’t set up for this client. */
export function isInvalidClientErrorBody(body: unknown): boolean {
  if (!body || typeof body !== 'object') return false
  return (body as Record<string, unknown>).error === 'invalid_client'
}

function firstFieldError(o: Record<string, unknown>): string | null {
  for (const v of Object.values(o)) {
    if (Array.isArray(v) && v.length > 0 && typeof v[0] === 'string')
      return v[0]
    if (typeof v === 'string') return v
  }
  return null
}

function messageFromBody(data: unknown, fallback: string): string {
  if (data && typeof data === 'object') {
    const o = data as Record<string, unknown>
    if (typeof o.detail === 'string') return o.detail
    if (typeof o.error === 'string') return o.error
    if (Array.isArray(o.non_field_errors) && o.non_field_errors[0])
      return String(o.non_field_errors[0])
    const field = firstFieldError(o)
    if (field) return field
  }
  return fallback
}

export async function apiFetch<T>(
  path: string,
  init: RequestInit = {},
): Promise<T> {
  const base = getApiBase()
  const token = useAuthStore.getState().accessToken
  const headers = new Headers(init.headers)
  if (token) headers.set('Authorization', `Bearer ${token}`)
  if (
    init.body &&
    !(init.body instanceof FormData) &&
    !headers.has('Content-Type')
  ) {
    headers.set('Content-Type', 'application/json')
  }

  const url =
    path.startsWith('http://') || path.startsWith('https://')
      ? path
      : `${base}${path}`
  const res = await fetch(url, { ...init, headers })
  const text = await res.text()
  let data: unknown = null
  if (text) {
    try {
      data = JSON.parse(text)
    } catch {
      data = text
    }
  }

  if (res.status === 401) {
    useAuthStore.getState().clearSession()
    if (!path.includes('/login/')) {
      window.location.href = '/sign-in'
    }
  }

  if (!res.ok) {
    throw new ApiError(
      res.status,
      messageFromBody(data, res.statusText || 'Request failed'),
      data,
    )
  }

  return data as T
}

export async function publicFetch<T>(
  path: string,
  init: RequestInit = {},
): Promise<T> {
  const base = getApiBase()
  const headers = new Headers(init.headers)
  if (
    init.body &&
    !(init.body instanceof FormData) &&
    !headers.has('Content-Type')
  ) {
    headers.set('Content-Type', 'application/json')
  }
  const res = await fetch(`${base}${path}`, { ...init, headers })
  const text = await res.text()
  let data: unknown = null
  if (text) {
    try {
      data = JSON.parse(text)
    } catch {
      data = text
    }
  }
  if (!res.ok) {
    throw new ApiError(
      res.status,
      messageFromBody(data, res.statusText || 'Request failed'),
      data,
    )
  }
  return data as T
}
