import { Controller } from "@hotwired/stimulus"

// Accessible mobile menu toggle with icon swap and aria-expanded.
export default class extends Controller {
  static targets = ["panel", "button", "openIcon", "closeIcon"]

  connect() {
    this._syncUI(false)
  }

  toggle() {
    if (!this.hasPanelTarget) return
    const isOpen = this.panelTarget.classList.contains("hidden") ? true : false
    this.panelTarget.classList.toggle("hidden")
    this._syncUI(isOpen)
  }

  _syncUI(open) {
    if (this.hasButtonTarget) this.buttonTarget.setAttribute("aria-expanded", open ? "true" : "false")
    if (this.hasOpenIconTarget) this.openIconTarget.classList.toggle("hidden", open)
    if (this.hasCloseIconTarget) this.closeIconTarget.classList.toggle("hidden", !open)
  }
}
