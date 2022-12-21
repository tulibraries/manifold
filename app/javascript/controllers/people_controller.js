import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  departments(event) {
    let type = event["target"]["value"]
    window.location.href = "/people?department="+type+"&page=1";
  }
  specialties(event) {
    let type = event["target"]["value"]
    window.location.href = "/people?specialty="+type+"&page=1";
  }
}
