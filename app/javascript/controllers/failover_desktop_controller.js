import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    $("#failover-desktop-search-form").submit(function(){
      var query = document.getElementById("failover-desktop-search-form").elements[0].value;
      var delims = "any,contains,";
      document.getElementById("failover-desktop-search-form").elements[0].style.setProperty("color", "white", "important");
      document.getElementById("failover-desktop-search-form").elements[0].value = delims+query;
    });
  }
}