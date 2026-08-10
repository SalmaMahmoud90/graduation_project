import { apiFetch, publicFetch } from '@/api/http'
import type { LoginResponse } from '@/api/types-api'

export function loginRequest(email: string, password: string) {
  return publicFetch<LoginResponse>('/api/users/login/', {
    method: 'POST',
    body: JSON.stringify({ email, password }),
  })
}

export function logoutRequest() {
  return apiFetch<{ detail?: string }>('/api/users/logout/', {
    method: 'POST',
    body: JSON.stringify({}),
  })
}
