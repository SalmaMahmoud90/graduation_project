import {
  createContext,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from 'react'
import { useAuthStore } from '@/stores/auth-store'

export type AuthUser = {
  email: string
  displayName: string
}

type AuthContextValue = {
  user: AuthUser | null
  isAuthenticated: boolean
  signIn: (input: { email: string; password: string }) => Promise<void>
  signOut: () => Promise<void>
}

const AuthContext = createContext<AuthContextValue | undefined>(undefined)

export function AuthProvider({ children }: { children: ReactNode }) {
  const [hydrated, setHydrated] = useState(() =>
    useAuthStore.persist.hasHydrated(),
  )
  useEffect(
    () => useAuthStore.persist.onFinishHydration(() => setHydrated(true)),
    [],
  )

  const accessToken = useAuthStore((s) => s.accessToken)
  const user = useAuthStore((s) => s.user)
  const signInStore = useAuthStore((s) => s.signIn)
  const signOutStore = useAuthStore((s) => s.signOut)

  const value = useMemo<AuthContextValue>(
    () => ({
      user: user
        ? {
            email: user.email,
            displayName: user.name?.trim() || user.email,
          }
        : null,
      isAuthenticated: !!accessToken && user?.user_type === 'admin',
      signIn: async (input) => {
        await signInStore(input.email.trim(), input.password)
      },
      signOut: signOutStore,
    }),
    [accessToken, user, signInStore, signOutStore],
  )

  if (!hydrated) {
    return <div className="min-h-svh bg-background" aria-hidden />
  }

  return (
    <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
  )
}

export function useAuth() {
  const context = useContext(AuthContext)
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider')
  }
  return context
}
