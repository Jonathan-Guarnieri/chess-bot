import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  initialize() {
    this.from = null
  }

  click(event) {
    const el = event.currentTarget

    if (!this.from) {
      const elHasPiece = !!el.querySelector(".piece")
      if (elHasPiece) {
        this.from = el.id
        el.classList.add("selected-square")
      }
      return
    }

    const from = this.from
    const to = el.id
    this.from = null

    const prev = document.getElementById(from)
    prev.classList.remove("selected-square")
    const sameColorPieces =
      document.querySelector(`#${from} .white-piece`) &&
      document.querySelector(`#${to} .white-piece`) ||
      document.querySelector(`#${from} .black-piece`) &&
      document.querySelector(`#${to} .black-piece`)

    if (sameColorPieces) {
      this.from = to
      const next = document.getElementById(to)
      next.classList.add("selected-square")
      return
    }

    fetch("/moves", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Accept": "text/vnd.turbo-stream.html"
      },
      body: JSON.stringify({ from, to })
    })
    .then(r => r.text())
    .then(html => Turbo.renderStreamMessage(html))
  }
}
