/// <reference types="vite/client" />

interface ImportMetaEnv {
  /** API root without trailing slash, or empty / unset to use same-origin + Vite proxy */
  readonly VITE_API_BASE_URL?: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
