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

  async _select(elementId) {
    document.getElementById(elementId).classList.add("selected-square")
    const possibleMoves = await this._getPossibleMovesFrom(elementId)

    this._highlightPossibleMoves(possibleMoves)
  }

  _deselect(elementId) {
    this._removePossibleMoveHighlights()
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
    const playerMoveRequest = (callback) => {
      fetch("/player_move", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
          "Accept": "text/vnd.turbo-stream.html"
        },
        body: JSON.stringify({ from, to })
      })
      .then(r => {
        if (!r.ok) return null;
        return r.text();
      })
      .then(html => {
        Turbo.renderStreamMessage(html);
        callback()
      })
    }

    const botMoveRequest = () => {
      fetch("/bot_move", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
          "Accept": "text/vnd.turbo-stream.html"
        }
      })
      .then(r => r.text())
      .then(html => Turbo.renderStreamMessage(html))
    }

    playerMoveRequest(botMoveRequest);
  }

  async _getPossibleMovesFrom(square) {
    const r = await fetch("/possible_moves", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Accept": "application/json"
      },
      body: JSON.stringify({ square })
    })

    const data = await r.json()
    return data.possible_moves
  }

  _highlightPossibleMoves(possibleMoves) {
    this._removePossibleMoveHighlights()
    possibleMoves.forEach(square => {
      const el = document.getElementById(square)
      const elHasPiece = el.querySelector('img') !== null

      if (elHasPiece) {
        el.classList.add("possible-square-to-capture")
      } else {
        el.classList.add("possible-square-to-move")
      }
    });
  }

  _removePossibleMoveHighlights() {
    document.getElementById("board").querySelectorAll(".possible-square-to-move").forEach(el => el.classList.remove("possible-square-to-move"));
    document.getElementById("board").querySelectorAll(".possible-square-to-capture").forEach(el => el.classList.remove("possible-square-to-capture"));
  }
}
