import { Controller } from "@hotwired/stimulus"

// Controller tìm kiếm tự động, giữ input focus
export default class extends Controller {
  static targets = ["form"]

  connect() {
    this.timeout = null
  }

  update() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      const form = this.formTarget
      const url = new URL(form.action, window.location.origin)
      const params = new URLSearchParams(new FormData(form)).toString()

      // Turbo visit để chỉ replace frame danh sách
      Turbo.visit(`${url}?${params}`, { frame: "food_drinks_list", action: "replace" })
    }, 300) // 300ms sau khi dừng gõ
  }
}
