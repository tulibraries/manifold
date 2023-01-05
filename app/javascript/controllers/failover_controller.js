import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    $("#failover-global-search").submit(function(){
      var query = document.getElementById("failover-global-search").elements[0].value;
      var delims = "any,contains,";
      document.getElementById("failover-global-search").elements[0].style.color = "white";
      document.getElementById("failover-global-search").elements[0].value = delims+query;
    });
    $("#failover-mobile-search-form").submit(function(){
      var query = document.getElementById("failover-mobile-search-form").elements[0].value;
      var delims = "any,contains,";
      document.getElementById("failover-mobile-search-form").elements[0].style.color = "white";
      document.getElementById("failover-mobile-search-form").elements[0].value = delims+query;
    });
    $("#failover-global-mobile-search-form").submit(function(){
      var query = document.getElementById("failover-global-mobile-search-form").elements[0].value;
      var delims = "any,contains,";
      document.getElementById("failover-global-mobile-search-form").elements[0].style.color = "white";
      document.getElementById("failover-global-mobile-search-form").elements[0].value = delims+query;
    });
    $("#failover-desktop-search-form").submit(function(){
      var query = document.getElementById("failover-desktop-search-form").elements[0].value;
      var delims = "any,contains,";
      document.getElementById("failover-desktop-search-form").elements[0].style.setProperty("color", "white", "important");
      document.getElementById("failover-desktop-search-form").elements[0].value = delims+query;
    });
  }
}