export type SortDir = 'asc' | 'desc'

export function compareValues(a: unknown, b: unknown, dir: SortDir): number {
  const m = dir === 'asc' ? 1 : -1
  if (a == null && b == null) return 0
  if (a == null) return -m
  if (b == null) return m
  if (typeof a === 'number' && typeof b === 'number') return (a - b) * m
  const sa = typeof a === 'string' ? a : String(a)
  const sb = typeof b === 'string' ? b : String(b)
  return sa.localeCompare(sb, undefined, { sensitivity: 'base', numeric: true }) * m
}

export function sortRows<T>(
  rows: T[],
  getComparable: (row: T) => unknown,
  dir: SortDir,
): T[] {
  return [...rows].sort((a, b) =>
    compareValues(getComparable(a), getComparable(b), dir),
  )
}

