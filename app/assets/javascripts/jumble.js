$(document).ready(function() {  
  $(window).width() < 1200 ? mobile() : desktop();
});
$(window).resize(function() {  
  $(window).width() < 1200 ? mobile() : desktop();
});

function desktop () {
  $('#scrc-left').insertBefore('#scrc-description-container');
  $('#dsc-left').insertBefore('#dsc-description-container');
  $('#libchat_fe2bd0cb1f04720f51641c4f01b8e22e').appendTo('#chat-nav');
  x = $('#header-navbar').offset();
  x2 = $('#visitMenuButton').offset();
  x3 = $('#researchMenuButton').offset();
  $("#visit-links").css("left", -(x2.left)+x.left);
  $("#research-links").css("left", -(x3.left)+x.left);
}

function mobile () {
  $('#scrc-left').insertAfter('#scrc-description');
  $('#dsc-left').insertAfter('#dsc-description');
  $('#libchat_fe2bd0cb1f04720f51641c4f01b8e22e').appendTo('#chat-nav-mobile');
  x = $('#header-navbar').offset();
  x2 = $('#visitMenuButton').offset();
  x3 = $('#researchMenuButton').offset();
  x4 = $('#aboutMenuButton').offset();
  $("#about-links").css("left", -(x4.left)+x.left);
  $("#visit-links").css("left", -(x2.left)+x.left);
  $("#research-links").css("left", -(x3.left)+x.left);
  $("#about-links").css("width", $(window).width());
  $("#research-links").css("width", $(window).width());
  $("#visit-links").css("width", $(window).width());
}

