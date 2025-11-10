import { Controller } from "@hotwired/stimulus"

// Controller để tìm kiếm tự động (không cần Enter)
export default class extends Controller {
  static targets = ["form"]

  connect() {
    this.timeout = null
  }

  update() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      // Turbo xử lý submit form này
      this.formTarget.requestSubmit()
    }, 300) // 400ms sau khi dừng gõ
  }
}
