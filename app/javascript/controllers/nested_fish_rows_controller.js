import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  connect() {
    this.#syncRemoveButtons()
  }

  add(event) {
    event.preventDefault()
    const html = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, `${Date.now()}`)
    this.containerTarget.insertAdjacentHTML("beforeend", html)
    this.#syncRemoveButtons()
  }

  remove(event) {
    event.preventDefault()
    const row = event.currentTarget.closest("[data-nested-fish-rows-row]")
    if (!row || this.#rows.length <= 1) return
    row.remove()
    this.#syncRemoveButtons()
  }

  get #rows() {
    return this.containerTarget.querySelectorAll("[data-nested-fish-rows-row]")
  }

  #syncRemoveButtons() {
    const show = this.#rows.length > 1
    this.#rows.forEach((row) => {
      const btn = row.querySelector("[data-nested-fish-rows-remove]")
      if (btn) btn.hidden = !show
    })
  }
}
