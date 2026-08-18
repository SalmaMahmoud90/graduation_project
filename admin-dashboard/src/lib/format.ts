export function formatDateTime(iso: string, locale?: string) {
  try {
    return new Intl.DateTimeFormat(locale, {
      dateStyle: 'medium',
      timeStyle: 'short',
    }).format(new Date(iso))
  } catch {
    return iso
  }
}

/** Calendar date only (e.g. daily summary rows, which carry no time). */
export function formatDate(iso: string, locale?: string) {
  try {
    return new Intl.DateTimeFormat(locale, { dateStyle: 'medium' }).format(
      new Date(iso),
    )
  } catch {
    return iso
  }
}

/** Short date for dense axes, e.g. "Aug 14". */
export function formatDateShort(iso: string, locale?: string) {
  try {
    return new Intl.DateTimeFormat(locale, {
      month: 'short',
      day: 'numeric',
    }).format(new Date(iso))
  } catch {
    return iso
  }
}

/** Some departure values are a time of day only (no calendar date). */
export function formatRideDeparture(value: string, locale?: string) {
  if (!value) return '—'
  const asDate = new Date(value)
  if (!Number.isNaN(asDate.getTime())) {
    return formatDateTime(value, locale)
  }
  try {
    return new Intl.DateTimeFormat(locale, { timeStyle: 'short' }).format(
      new Date(`1970-01-01T${value}`),
    )
  } catch {
    return value
  }
}

export function formatNumber(n: number) {
  return new Intl.NumberFormat().format(n)
}

/** Between origin and destination; Arabic (RTL) uses a left-pointing arrow. */
export function routeSegmentSeparator(locale: string | undefined): string {
  return locale === 'ar' ? '←' : '→'
}

export function formatRouteLabel(
  origin: string,
  destination: string,
  locale: string | undefined,
): string {
  return `${origin} ${routeSegmentSeparator(locale)} ${destination}`
}
