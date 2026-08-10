import { create } from 'zustand'

/** Search text shared across list screens. */
export const useTableFiltersStore = create<{
  usersQuery: string
  ridesQuery: string
  bookingsQuery: string
  reportsQuery: string
  setUsersQuery: (q: string) => void
  setRidesQuery: (q: string) => void
  setBookingsQuery: (q: string) => void
  setReportsQuery: (q: string) => void
}>((set) => ({
  usersQuery: '',
  ridesQuery: '',
  bookingsQuery: '',
  reportsQuery: '',
  setUsersQuery: (usersQuery) => set({ usersQuery }),
  setRidesQuery: (ridesQuery) => set({ ridesQuery }),
  setBookingsQuery: (bookingsQuery) => set({ bookingsQuery }),
  setReportsQuery: (reportsQuery) => set({ reportsQuery }),
}))
