// This file configures the Google Analytics Tracking service.

$(document).ready(function(){

	setTimeout(function(){
    
    $('form#main-search').on('keypress', function (evt) {
      if (evt.keyCode == 13) {
        handleEventClicks("main-search", "Search");
      }
    });

    $('form#header-search').on('keypress', function (evt) {
      if (evt.keyCode == 13) {
        handleEventClicks("header-search", "Search");
      }
    });

    dc = document.querySelector('a[href="https://digital.library.temple.edu/"]');
    if(dc) dc.setAttribute("id","digcol")

		tracks = [
      {id: "digcol", category: "Outbound Links"},
      {id: "main-search", category: "Search"},
      {id: "header-search", category: "Search"}
		];

	  handleEventClicks = (label, category) => {
	    if (typeof ga != "undefined") {
	      ga("send", "event", {
	        eventCategory: category,
	        eventAction: "click",
	        eventLabel: label,
	        forceSSL: true,
	        anonymizeIp: true
	      });
	    };
	  };

		tracks.forEach((track) => {
			if(track.id) {
				if (el = document.getElementById(track.id)) {
					el.addEventListener("click", () => {
				    handleEventClicks(track.id, track.category)
					});
				};
			}
		});
	},2000);
});
