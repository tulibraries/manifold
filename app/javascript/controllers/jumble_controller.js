import { Controller } from "@hotwired/stimulus"
import { useWindowResize } from 'stimulus-use'

export default class extends Controller {
  static targets = ['width']
  connect() {
    useWindowResize(this)
  }
  windowResize({ width, height, event }) {
    width < 1200 ? this.mobile() : this.desktop()
  }

  desktop () {
    $('#scrc-left').insertBefore('#scrc-description-container');
    $('#dsc-left').insertBefore('#dsc-description-container');
    $('#libchat_fe2bd0cb1f04720f51641c4f01b8e22e').appendTo('#chat-nav');
    var x = $('#header-top').offset();
    var x2 = $('#aboutMenuButton').offset();
    var x3 = $('#visitMenuButton').offset();
    var x4 = $('#researchMenuButton').offset();
    $("#about-links").css("left", x.left - x2.left);
    $("#visit-links").css("left", x.left - x3.left);
    $("#research-links").css("left", x.left - x4.left);
  }

  mobile () {
    $('#scrc-left').insertAfter('#scrc-description');
    $('#dsc-left').insertAfter('#dsc-description');
    $('#libchat_fe2bd0cb1f04720f51641c4f01b8e22e').appendTo('#chat-nav-mobile');
    var x = $('#header-top').offset();
    var x2 = $('#aboutMenuButton').offset();
    var x3 = $('#visitMenuButton').offset();
    var x4 = $('#researchMenuButton').offset();
    $("#about-links").css("left", -(x2.left)+x.left);
    $("#visit-links").css("left", -(x3.left)+x.left);
    $("#research-links").css("left", -(x4.left)+x.left);
    $("#about-links").css("width", $(window).width());
    $("#visit-links").css("width", $(window).width());
    $("#research-links").css("width", $(window).width());
  }

}


