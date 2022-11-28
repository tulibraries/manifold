import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    var c = document.getElementsByTagName("a");
    var a = 0;
    for(a; a < c.length; a++) {
      var b = c[a];
      b.getAttribute("href") && b.hostname !== location.hostname && (b.target = "_blank")
    }
  }
}