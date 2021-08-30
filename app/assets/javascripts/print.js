function printPage() {
  window.print();
}

$(document).ready(function() {
  spec_print = document.getElementById('spec_print');
  if(spec_print) {
    window.print();
  }
});