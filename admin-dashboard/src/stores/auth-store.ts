import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import { loginRequest, logoutRequest } from '@/api/auth-api'

export type SessionUser = {
  email: string
  name: string | null
  user_type: string
}

type AuthState = {
  accessToken: string | null
  refreshToken: string | null
  user: SessionUser | null
  clearSession: () => void
  signIn: (email: string, password: string) => Promise<void>
  signOut: () => Promise<void>
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set, get) => ({
      accessToken: null,
      refreshToken: null,
      user: null,
      clearSession: () =>
        set({ accessToken: null, refreshToken: null, user: null }),
      signIn: async (email, password) => {
        const data = await loginRequest(email, password)
        if (!data.access_token) {
          throw new Error('NO_TOKEN')
        }
        if (data.user?.user_type !== 'admin') {
          throw new Error('ADMIN_ONLY')
        }
        set({
          accessToken: data.access_token,
          refreshToken: data.refresh_token ?? null,
          user: {
            email: data.user.email,
            name: data.user.name ?? null,
            user_type: data.user.user_type,
          },
        })
      },
      signOut: async () => {
        try {
          if (get().accessToken) await logoutRequest()
        } catch {
          /* token may already be invalid */
        }
        get().clearSession()
      },
    }),
    {
      name: 'atareeqak-admin-auth',
      partialize: (s) => ({
        accessToken: s.accessToken,
        refreshToken: s.refreshToken,
        user: s.user,
      }),
    },
  ),
)
