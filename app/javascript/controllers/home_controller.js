// extrair esse arquivo para uma controller de board, nao de home
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  initialize() {
    this.from = null
  }

  click(event) {
    const el = event.currentTarget

    // Handle the first click:
    if (!this.from) {
      const isPiece = !!el.querySelector(".piece")
      if (isPiece) this._setFrom(el.id)
      return
    }

    // Handle the second click:
    const from = this.from
    const to = el.id

    this._deselect(from)

    if (this._sameColorPieces(from, to)) {
      this._setFrom(to)
      return
    }

    this.from = null
    this._postMove(from, to)
  }

  _setFrom(from) {
    this.from = from
    this._select(from)
  }

  _select(elementId) {
    document.getElementById(elementId).classList.add("selected-square")
  }

  _deselect(elementId) {
    document.getElementById(elementId).classList.remove("selected-square")
  }

  _sameColorPieces(from, to) {
    return (
      document.querySelector(`#${from} .white-piece`) &&
      document.querySelector(`#${to} .white-piece`) ||
      document.querySelector(`#${from} .black-piece`) &&
      document.querySelector(`#${to} .black-piece`)
    )
  }

  _postMove(from, to) {
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
