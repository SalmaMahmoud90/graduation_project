import {
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from 'react'
import { locales, type Locale, translations } from '@/i18n/translations'
import { I18nContext, type I18nContextValue, type TranslateParams } from '@/contexts/i18n'

const LOCALE_STORAGE_KEY = 'admin-dashboard-locale'

function isLocale(value: string): value is Locale {
  return locales.includes(value as Locale)
}

function resolveInitialLocale(): Locale {
  const stored = localStorage.getItem(LOCALE_STORAGE_KEY)
  if (stored && isLocale(stored)) return stored

  const browserLang = navigator.language.toLowerCase()
  if (browserLang.startsWith('ar')) return 'ar'
  return 'en'
}

function translate(locale: Locale, key: string, params?: TranslateParams) {
  const template = translations[locale][key] ?? translations.en[key] ?? key
  if (!params) return template

  return template.replaceAll(
    /\{(\w+)\}/g,
    (_, param: string) => String(params[param] ?? `{${param}}`),
  )
}

export function I18nProvider({ children }: { children: ReactNode }) {
  const [locale, setLocale] = useState<Locale>(resolveInitialLocale)

  useEffect(() => {
    localStorage.setItem(LOCALE_STORAGE_KEY, locale)
    document.documentElement.lang = locale
    document.documentElement.dir = locale === 'ar' ? 'rtl' : 'ltr'
  }, [locale])

  const value = useMemo<I18nContextValue>(
    () => ({
      locale,
      setLocale,
      t: (key, params) => translate(locale, key, params),
    }),
    [locale],
  )

  return <I18nContext.Provider value={value}>{children}</I18nContext.Provider>
}
