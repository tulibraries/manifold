import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    $("#failover-mobile-search-form").submit(function(){
      var query = document.getElementById("failover-mobile-search-form").elements[0].value;
      var delims = "any,contains,";
      document.getElementById("failover-mobile-search-form").elements[0].style.color = "white";
      document.getElementById("failover-mobile-search-form").elements[0].value = delims+query;
    });
  }
}