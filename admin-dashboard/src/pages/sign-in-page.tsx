import { useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import { toast } from 'sonner'
import { ApiError, isInvalidClientErrorBody } from '@/api/http'
import { Button } from '@/components/ui/button'
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { useAuth } from '@/contexts/auth-context'
import { useI18n } from '@/contexts/i18n'
import { BRAND_LOGO_SRC, BRAND_NAME } from '@/lib/brand'

export function SignInPage() {
  const navigate = useNavigate()
  const location = useLocation()
  const { signIn } = useAuth()
  const { locale, setLocale, t } = useI18n()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [busy, setBusy] = useState(false)

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!email.trim() || !password.trim()) return

    setBusy(true)
    try {
      await signIn({ email: email.trim(), password })
      const redirectTo = (
        location.state as { from?: { pathname?: string } } | null
      )?.from?.pathname
      navigate(redirectTo || '/', { replace: true })
    } catch (err) {
      if (err instanceof ApiError) {
        if (isInvalidClientErrorBody(err.body)) {
          toast.error(t('auth.signIn.configIssue'))
        } else {
          toast.error(err.message)
        }
      } else if (err instanceof Error && err.message === 'ADMIN_ONLY') {
        toast.error(t('auth.signIn.adminOnly'))
      } else if (err instanceof Error && err.message === 'NO_TOKEN') {
        toast.error(t('auth.signIn.failed'))
      } else {
        toast.error(t('auth.signIn.failed'))
      }
    } finally {
      setBusy(false)
    }
  }

  return (
    <div className="flex min-h-svh items-center justify-center bg-gradient-to-br from-background via-background to-primary/[0.08] p-4">
      <Card className="w-full max-w-md border-primary/15 shadow-sm shadow-primary/5">
        <CardHeader className="space-y-4">
          <div className="flex justify-end">
            <Button
              type="button"
              variant="outline"
              size="sm"
              className="h-8 px-2 text-xs"
              onClick={() => setLocale(locale === 'en' ? 'ar' : 'en')}
              aria-label={t('app.toggleLocale')}
            >
              {locale === 'en' ? t('app.locale.ar') : t('app.locale.en')}
            </Button>
          </div>
          <div className="flex flex-col items-center gap-3 text-center">
            <img
              src={BRAND_LOGO_SRC}
              alt={BRAND_NAME}
              width={150}
              className="invert dark:filter-none"
            />
            <div className="space-y-1">
              <CardTitle className="text-2xl">{t('auth.signIn.title')}</CardTitle>
              <CardDescription className="text-pretty">
                {t('auth.signIn.description')}
              </CardDescription>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <form className="space-y-4" onSubmit={onSubmit}>
            <div className="space-y-2">
              <Label htmlFor="email">{t('auth.signIn.email')}</Label>
              <Input
                id="email"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder={t('auth.signIn.emailPlaceholder')}
                autoComplete="email"
                disabled={busy}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="password">{t('auth.signIn.password')}</Label>
              <Input
                id="password"
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder={t('auth.signIn.passwordPlaceholder')}
                autoComplete="current-password"
                disabled={busy}
              />
            </div>
            <Button type="submit" className="w-full" disabled={busy}>
              {busy ? t('auth.signIn.submitting') : t('auth.signIn.submit')}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  )
}
