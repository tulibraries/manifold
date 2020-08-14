$(document).ready(function() {  
  $(window).width() < 1040 ? mobile() : desktop();
});
$(window).resize(function() {  
  $(window).width() < 1040 ? mobile() : desktop();
});

function desktop () {
  $('#scrc-left').insertBefore('#scrc-description-container');
  $('#dsc-left').insertBefore('#dsc-description-container');
  $('#libchat_fe2bd0cb1f04720f51641c4f01b8e22e').appendTo('#chat-nav');
}

function mobile () {
  $('#scrc-left').insertAfter('#scrc-description');
  $('#dsc-left').insertAfter('#dsc-description');
  $('#libchat_fe2bd0cb1f04720f51641c4f01b8e22e').appendTo('#chat-nav-mobile');
}

