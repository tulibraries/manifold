$(document).ready(function() {  
  if ($(window).width() < 1040) {
    $('#scrc-left').insertAfter('#scrc-description');
    $('#dsc-left').insertAfter('#dsc-description');
  }
  if($(window).width() > 1040) {
    $('#scrc-left').insertBefore('#scrc-description-container');
    $('#dsc-left').insertBefore('#dsc-description-container');
  }
});

$(window).on('resize', function() {
  if ($(window).width() < 1040) {
    $('#scrc-left').insertAfter('#scrc-description');
    $('#dsc-left').insertAfter('#dsc-description');
  }
  if($(window).width() > 1040) {
    $('#scrc-left').insertBefore('#scrc-description-container');
    $('#dsc-left').insertBefore('#dsc-description-container');
  }
});
