// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require jquery
//= require popper
//= require bootstrap-sprockets
//= require jquery_ujs
//= require tinymce-jquery
//= require turbolinks
//= require_tree .

function toggle(x) {
  // if (x instanceof Object) {
  //   x.classList.toggle("change");
  // }
  // else {
  //   document.getElementById(x).classList.toggle("change");
  // }
  if (x == "secondary") {
  	document.getElementById("sub-toggler-icon").classList.toggle("change");
  }
  else {
  	document.getElementById("main-toggler-icon").classList.toggle("change");
  }

}

// TO BE IMPLEMENTED LATER REPLACING THE ONCLICK OF MENU ICONS
// $('<span>', {
// 	'class': 'button', // So you can style it
// 	role: 'button', // Tell assistive technology it's a button
// 	tabindex: '0', // Make it keyboard focusable
// 	click: function() { // Make something happen when it is clicked
// 		alert('You clicked me!');
// 	},
// 	keydown: function(e) { // Trigger the click event from the keyboard
// 		var code = e.which;
// 		// 13 = Return, 32 = Space
// 		if ((code === 13) || (code === 32)) {
// 			$(this).click();
// 		}
// 	},
// 	html: 'Click me!'
// }).appendTo($('#button-container'));