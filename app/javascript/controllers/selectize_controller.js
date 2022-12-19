import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    $("select").selectize();
    $("select.limited").selectize({
      maxItems: 3,
    });
  }
}