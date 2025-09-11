import { BridgeComponent, BridgeElement } from "@hotwired/hotwire-native-bridge"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends BridgeComponent {
  static component = "toolbar"

  connect() {
    super.connect()

    const element = this.bridgeElement instanceof BridgeElement ? this.bridgeElement : new BridgeElement(this.element)
    const defaultTitle = element.title || "Your Tasks"
    const showAddAttr = element.bridgeAttribute("show-add") || element.bridgeAttribute("showAdd")
    const defaultShowAdd = showAddAttr == null ? true : String(showAddAttr).toLowerCase() === "true"

    this.receive("toolbar.addTapped", () => {
      Turbo.visit("/tasks/new", { action: "advance" })
    })

    this.configure(defaultTitle, defaultShowAdd)
  }

  configure(title, showAdd = true) {
    this.send("configure", { title, showAdd })
  }

  show() {
    this.send("show")
  }

  hide() {
    this.send("hide")
  }

  setTitle(title) {
    this.send("setTitle", { title })
  }
}


