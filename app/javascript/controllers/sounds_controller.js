// sound_event_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { name: String }

  connect() {
    const audio = document.getElementById(`sound-${this.nameValue}`)
    audio.currentTime = 0
    audio.play()
    this.element.remove()
  }
}