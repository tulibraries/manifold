$(document).ready(function() {  
  if ($(window).width() < 1040) {
    $('#scrc-left').insertAfter('#scrc-description');
    $('#dsc-left').insertAfter('#dsc-description');
    $('#libchat_fe2bd0cb1f04720f51641c4f01b8e22e').appendTo('#chat-nav-mobile');

  }
  if($(window).width() > 1040) {
    $('#scrc-left').insertBefore('#scrc-description-container');
    $('#dsc-left').insertBefore('#dsc-description-container');
    $('#libchat_fe2bd0cb1f04720f51641c4f01b8e22e').appendTo('#chat-nav');
  }
  if ($(window).width() < 1040) {
    $('#events-signup').insertAfter('#events');
  }
  if($(window).width() > 1040) {
    $('#events-signup').appendTo('#events-leftside');
  }
});

$(window).on('resize', function() {
  if ($(window).width() < 1040) {
    $('#scrc-left').insertAfter('#scrc-description');
    $('#dsc-left').insertAfter('#dsc-description');
    $('#libchat_fe2bd0cb1f04720f51641c4f01b8e22e').appendTo('#chat-nav-mobile');
  }
  if($(window).width() > 1040) {
    $('#scrc-left').insertBefore('#scrc-description-container');
    $('#dsc-left').insertBefore('#dsc-description-container');
    $('#libchat_fe2bd0cb1f04720f51641c4f01b8e22e').appendTo('#chat-nav');
  }
  if ($(window).width() < 1040) {
    $('#events-signup').insertAfter('#events');
  }
  if($(window).width() > 1040) {
    $('#events-signup').appendTo('#events-leftside');
  }
});
