import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    $("#nav-sec21a-tab").click(function() {
      $('html, body').animate({
          scrollTop: $("#nav-tabs").offset().top
      }, 1000);
    });
    $("#nav-sec21b-tab").click(function() {
      $('html, body').animate({
          scrollTop: $("#nav-tabs").offset().top
      }, 1000);
    });
    $("#nav-sec22-tab").click(function() {
      $('html, body').animate({
          scrollTop: $("#nav-tabs").offset().top
      }, 1000);
    });
    $("#nav-sec23-tab").click(function() {
      $('html, body').animate({
          scrollTop: $("#nav-tabs").offset().top
      }, 1000);
    });
  }
}