$(document).ready(function() {  
  if ($(window).width() < 1040) {
    $('#scrc-left').insertAfter('#scrc-description');
  }
  if($(window).width() > 1040) {
    $('#scrc-left').insertBefore('#scrc-description-container');
  }
});

$(window).on('resize', function() {
  if ($(window).width() < 1040) {
    $('#scrc-left').insertAfter('#scrc-description');
  }
  if($(window).width() > 1040) {
    $('#scrc-left').insertBefore('#scrc-description-container');
  }
});
