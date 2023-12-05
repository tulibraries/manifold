import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['professor', 'course']

  sort_column(event) {
    let column = event.currentTarget.dataset.column
    let direction = event.currentTarget.dataset.direction
    if (direction == "asc") {
      if (column == "course") {
        window.location.href = "/etextbooks?column=course&direction=desc"
      }
      else {
        window.location.href = "/etextbooks?column=professor&direction=desc"
      }
    }
    else if (direction == "desc") {
      if (column == "course") {
        window.location.href = "/etextbooks?column=course&direction=asc"
      }
      else {
        window.location.href = "/etextbooks?column=professor&direction=asc"
      }
    }
  }
}
