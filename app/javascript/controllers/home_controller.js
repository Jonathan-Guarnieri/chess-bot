import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  initialize() {
    this.from = null
  }

  click(event) {
    const id = event.currentTarget.id

    if (!this.from) {
      this.from = id
      return
    }

    const from = this.from
    const to = id
    this.from = null

    const token = document.querySelector('meta[name="csrf-token"]').content

    fetch("/moves", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
        "Accept": "text/vnd.turbo-stream.html"
      },
      body: JSON.stringify({ from, to })
    })
    .then(r => r.text())
    .then(html => Turbo.renderStreamMessage(html))
  }
}