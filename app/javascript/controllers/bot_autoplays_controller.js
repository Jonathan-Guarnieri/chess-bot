import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { activePlayer: String }

  // Auto-play if it’s the bot’s turn.
  //
  // IMPORTANT: Browsers block audio autoplay. A sound cannot play until the user
  // interacts with the page first, such as clicking or tapping. If the page tries
  // to play audio before any user interaction, the browser will reject the
  // request and the sound will not play.
  connect() {
    // TODO: Update this logic when adding support for playing as Black.
    const isBotTurn = this.activePlayerValue === 'black'
    if (!isBotTurn) return

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
}
