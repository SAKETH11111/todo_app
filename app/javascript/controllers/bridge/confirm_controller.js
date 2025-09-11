import { BridgeComponent, BridgeElement } from "@hotwired/hotwire-native-bridge"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends BridgeComponent {
  static component = "confirm"
  static get shouldLoad() { return true }

  connect() {
    super.connect()
    console.debug("[bridge--confirm] connected", { enabled: this.enabled })
  }

  disconnect() {
    // no-op
  }

  request(event) {
    event.preventDefault()
    event.stopPropagation()

    const el = this.bridgeElement instanceof BridgeElement ? this.bridgeElement : new BridgeElement(this.element)
    const id = el.bridgeAttribute("id-param") || el.bridgeAttribute("id")
    const title = el.bridgeAttribute("title-param") || el.bridgeAttribute("title") || "this task"
    const message = el.bridgeAttribute("message-param") || `Delete ${title}?`

    if (!id) {
      console.warn("[bridge--confirm] missing id-param/title-param on element", this.element)
      return
    }

    this.pendingId = String(id)
    if (this.enabled) {
      console.debug("[bridge--confirm] invoking native confirm", { id: this.pendingId })
      this.send("show", { id: this.pendingId, title, message }, () => {
        console.debug("[bridge--confirm] native accepted", { id: this.pendingId })
        this.deleteById(this.pendingId)
      })
    } else {
      console.debug("[bridge--confirm] using web confirm fallback", { id: this.pendingId })
      if (window.confirm(message)) {
        this.deleteById(this.pendingId)
      }
    }
  }

  async deleteById(id) {
    const token = document.querySelector('meta[name="csrf-token"]').getAttribute("content")
    const response = await fetch(`/tasks/${id}`, {
      method: "DELETE",
      headers: {
        "X-CSRF-Token": token,
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
    const html = await response.text()
    console.debug("[bridge--confirm] delete response", { status: response.status, ok: response.ok, length: html?.length })
    if (response.ok && html) {
      Turbo.renderStreamMessage(html)
    }
  }
}


