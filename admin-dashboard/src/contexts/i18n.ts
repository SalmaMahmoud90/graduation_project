import { createContext, useContext } from 'react'
import type { Locale } from '@/i18n/translations'

export type TranslateParams = Record<string, string | number>

export type I18nContextValue = {
  locale: Locale
  setLocale: (locale: Locale) => void
  t: (key: string, params?: TranslateParams) => string
}

export const I18nContext = createContext<I18nContextValue | undefined>(undefined)

export function useI18n() {
  const context = useContext(I18nContext)
  if (!context) {
    throw new Error('useI18n must be used within I18nProvider')
  }

  return context
}
