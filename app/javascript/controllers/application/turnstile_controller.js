import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]
  static values = { siteKey: String }

  connect() {
    this.render = this.render.bind(this)
    this.handlePageShow = this.handlePageShow.bind(this)

    this.render()
    window.addEventListener("pageshow", this.handlePageShow)
    document.addEventListener("turbo:load", this.render)
  }

  disconnect() {
    window.removeEventListener("pageshow", this.handlePageShow)
    document.removeEventListener("turbo:load", this.render)
  }

  handlePageShow(event) {
    if (event.persisted) this.render(true)
  }

  render(force = false) {
    if (!window.turnstile || !this.hasContainerTarget) return
    if (this.widgetId && !force) return

    if (force) {
      this.containerTarget.innerHTML = ""
      this.widgetId = null
    }

    this.widgetId = window.turnstile.render(this.containerTarget, {
      sitekey: this.siteKeyValue
    })
  }
}