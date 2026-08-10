import { useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { toast } from 'sonner'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table'
import { Skeleton } from '@/components/ui/skeleton'
import { Input } from '@/components/ui/input'
import { TablePagination } from '@/components/table/table-pagination'
import {
  useReportDetail,
  useReportsPage,
  useRides,
  useSendReportNote,
  useUsers,
} from '@/hooks/use-admin-queries'
import { formatDateTime, formatRouteLabel } from '@/lib/format'
import { useTableFiltersStore } from '@/stores/table-filters-store'
import type { ReportStatus } from '@/types/domain'
import { useI18n } from '@/contexts/i18n'

function reportBadge(status: ReportStatus, t: (key: string) => string) {
  const map: Record<
    ReportStatus,
    { label: string; variant: 'default' | 'secondary' | 'outline' | 'destructive' }
  > = {
    pending: { label: t('reports.status.pending'), variant: 'destructive' },
    reviewed: { label: t('reports.status.reviewed'), variant: 'secondary' },
  }
  const m = map[status]
  return <Badge variant={m.variant}>{m.label}</Badge>
}

function typeLabel(type: string, t: (key: string) => string) {
  const known = ['spam', 'harassment', 'fake', 'dangerous', 'other']
  return known.includes(type) ? t(`reports.type.${type}`) : type
}

function ReportNoteDialog({ id }: { id: string }) {
  const { t } = useI18n()
  const [open, setOpen] = useState(false)
  const { data, isLoading } = useReportDetail(open ? id : undefined)
  const sendNote = useSendReportNote()
  const [note, setNote] = useState('')
  const [seeded, setSeeded] = useState(false)

  // Seed the textarea with the existing note once the detail loads (adjusting
  // state during render, per the React "reset on prop change" pattern).
  if (data && !seeded) {
    setSeeded(true)
    setNote(data.adminNote)
  }

  function onSave() {
    if (!note.trim()) {
      toast.error(t('reports.note.validate'))
      return
    }
    sendNote.mutate(
      { reportId: id, note: note.trim() },
      {
        onSuccess: () => {
          toast.success(t('reports.note.success'))
          setOpen(false)
        },
        onError: () => toast.error(t('reports.note.error')),
      },
    )
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger
        render={
          <Button size="sm" variant="outline">
            {t('reports.action.review')}
          </Button>
        }
      />
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{t('reports.detail.title')}</DialogTitle>
          <DialogDescription>{t('reports.detail.subtitle')}</DialogDescription>
        </DialogHeader>
        {isLoading || !data ? (
          <Skeleton className="h-24 w-full" />
        ) : (
          <div className="space-y-4">
            <dl className="grid grid-cols-[auto_1fr] gap-x-4 gap-y-2 text-sm">
              <dt className="text-muted-foreground">{t('reports.table.report')}</dt>
              <dd>{typeLabel(data.type, t)}</dd>
              <dt className="text-muted-foreground">{t('reports.detail.reason')}</dt>
              <dd className="whitespace-pre-wrap">{data.reason}</dd>
              <dt className="text-muted-foreground">{t('reports.table.status')}</dt>
              <dd>{reportBadge(data.status, t)}</dd>
            </dl>
            <div className="space-y-2">
              <Label htmlFor="report-note">{t('reports.detail.adminNote')}</Label>
              <Textarea
                id="report-note"
                value={note}
                onChange={(e) => setNote(e.target.value)}
                rows={4}
                placeholder={t('reports.detail.adminNotePlaceholder')}
              />
            </div>
          </div>
        )}
        <DialogFooter showCloseButton>
          <Button
            onClick={onSave}
            disabled={isLoading || !data || sendNote.isPending}
          >
            {sendNote.isPending
              ? t('reports.note.saving')
              : t('reports.note.save')}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}

export function ReportsPage() {
  const { locale, t } = useI18n()
  const query = useTableFiltersStore((s) => s.reportsQuery)
  const setQuery = useTableFiltersStore((s) => s.setReportsQuery)
  const [page, setPage] = useState(1)
  const [pageSize, setPageSize] = useState(10)
  const { data, isLoading, isError } = useReportsPage(page, pageSize)
  // Loaded once in the background to resolve reporter/reported/ride names; the
  // table is server-paginated and renders without waiting on these.
  const { data: users } = useUsers()
  const { data: rides } = useRides()

  const userNameById = useMemo(() => {
    const m = new Map<string, string>()
    users?.forEach((u) => m.set(u.id, u.fullName))
    return m
  }, [users])

  const rideLabelById = useMemo(() => {
    const m = new Map<string, string>()
    rides?.forEach((r) =>
      m.set(r.id, formatRouteLabel(r.origin, r.destination, locale)),
    )
    return m
  }, [rides, locale])

  const userName = (id: string) => (id ? userNameById.get(id) ?? `#${id}` : '')
  const rideLabel = (id: string) => (id ? rideLabelById.get(id) ?? `#${id}` : '')

  const filtered = useMemo(() => {
    if (!data) return []
    const q = query.trim().toLowerCase()
    if (!q) return data.results
    return data.results.filter(
      (r) =>
        r.type.toLowerCase().includes(q) ||
        r.reason.toLowerCase().includes(q) ||
        userName(r.reportedUserId).toLowerCase().includes(q) ||
        userName(r.reporterId).toLowerCase().includes(q) ||
        rideLabel(r.rideId).toLowerCase().includes(q) ||
        r.reportedUserId.toLowerCase().includes(q) ||
        r.reporterId.toLowerCase().includes(q) ||
        r.id.toLowerCase().includes(q),
    )
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [data, query, userNameById, rideLabelById])

  const hasNext = Boolean(data?.next)
  const total =
    data?.count ??
    (hasNext ? page * pageSize : (page - 1) * pageSize + filtered.length)
  const totalPages = data?.count
    ? Math.max(1, Math.ceil(data.count / pageSize))
    : Math.max(1, page + (hasNext ? 1 : 0))

  if (isError) {
    return (
      <p className="text-destructive text-sm">{t('reports.error')}</p>
    )
  }

  return (
    <div className="space-y-4">
      <div className="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
        <div>
          <h2 className="text-2xl font-semibold tracking-tight">
            {t('reports.title')}
          </h2>
          <p className="text-muted-foreground mt-1 text-sm max-w-xl">
            {t('reports.description')}
          </p>
        </div>
        <div className="w-full sm:max-w-xs">
          <Input
            placeholder={t('reports.searchPlaceholder')}
            value={query}
            onChange={(e) => {
              setQuery(e.target.value)
              setPage(1)
            }}
            aria-label={t('reports.searchAria')}
          />
        </div>
      </div>

      <p className="text-muted-foreground text-xs md:hidden">
        {t('table.scrollHint')}
      </p>

      <div className="flex flex-col overflow-hidden rounded-md border">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>{t('reports.table.report')}</TableHead>
              <TableHead>{t('reports.table.reportedUser')}</TableHead>
              <TableHead>{t('reports.table.reporter')}</TableHead>
              <TableHead>{t('reports.table.ride')}</TableHead>
              <TableHead>{t('reports.table.status')}</TableHead>
              <TableHead>{t('reports.table.opened')}</TableHead>
              <TableHead className="text-start">
                {t('reports.table.actions')}
              </TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {isLoading &&
              Array.from({ length: 4 }).map((_, i) => (
                <TableRow key={i}>
                  <TableCell colSpan={7}>
                    <Skeleton className="h-12 w-full" />
                  </TableCell>
                </TableRow>
              ))}
            {!isLoading &&
              filtered.map((r) => (
                <TableRow key={r.id} className="align-top">
                  <TableCell className="max-w-md">
                    <div className="flex flex-col gap-1">
                      <span className="text-xs font-medium uppercase text-muted-foreground">
                        {typeLabel(r.type, t)}
                      </span>
                      <span className="text-sm">{r.reason}</span>
                      <span className="text-muted-foreground text-xs">{r.id}</span>
                    </div>
                  </TableCell>
                  <TableCell>
                    {r.reportedUserId ? (
                      <Link
                        to={`/users/${r.reportedUserId}`}
                        className="flex flex-col underline-offset-4 hover:underline focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring rounded-sm w-fit"
                      >
                        <span className="font-medium">
                          {userName(r.reportedUserId)}
                        </span>
                        <span className="text-muted-foreground text-xs">
                          #{r.reportedUserId}
                        </span>
                      </Link>
                    ) : (
                      <span className="text-muted-foreground text-xs">—</span>
                    )}
                  </TableCell>
                  <TableCell>
                    {r.reporterId ? (
                      <Link
                        to={`/users/${r.reporterId}`}
                        className="flex flex-col underline-offset-4 hover:underline focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring rounded-sm w-fit"
                      >
                        <span>{userName(r.reporterId)}</span>
                        <span className="text-muted-foreground text-xs">
                          #{r.reporterId}
                        </span>
                      </Link>
                    ) : (
                      <span className="text-muted-foreground text-xs">—</span>
                    )}
                  </TableCell>
                  <TableCell>
                    {r.rideId ? (
                      <Link
                        to={`/rides/${r.rideId}`}
                        className="underline-offset-4 hover:underline focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring rounded-sm"
                      >
                        {rideLabel(r.rideId)}
                      </Link>
                    ) : (
                      <span className="text-muted-foreground text-xs">—</span>
                    )}
                  </TableCell>
                  <TableCell>{reportBadge(r.status, t)}</TableCell>
                  <TableCell className="text-muted-foreground text-sm">
                    {formatDateTime(r.createdAt, locale)}
                  </TableCell>
                  <TableCell>
                    <ReportNoteDialog id={r.id} />
                  </TableCell>
                </TableRow>
              ))}
          </TableBody>
        </Table>
        {!isLoading && filtered.length > 0 ? (
          <TablePagination
            page={page}
            pageSize={pageSize}
            total={total}
            totalPages={totalPages}
            onPageChange={setPage}
            onPageSizeChange={(n) => {
              setPageSize(n)
              setPage(1)
            }}
          />
        ) : null}
      </div>
    </div>
  )
}
