import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    $("#failover-global-mobile-search-form").submit(function(){
      var query = document.getElementById("failover-global-mobile-search-form").elements[0].value;
      var delims = "any,contains,";
      document.getElementById("failover-global-mobile-search-form").elements[0].style.color = "white";
      document.getElementById("failover-global-mobile-search-form").elements[0].value = delims+query;
    });
  }
}