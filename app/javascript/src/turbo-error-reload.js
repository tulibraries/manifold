// Turbo renders error responses (4xx/5xx) by replacing <head> and re-running
// every script on the page, which breaks third-party widgets like CookieChimp.
// For page visits that fail, do a full page load instead.
document.addEventListener("turbo:before-fetch-response", (event) => {
  // Page visits fire on documentElement; prefetches, forms, and frames fire on
  // their own elements and are left to Turbo.
  if (event.target !== document.documentElement) return

  const response = event.detail.fetchResponse
  if (response.failed) {
    event.preventDefault()
    window.location.href = response.location.href
  }
})
