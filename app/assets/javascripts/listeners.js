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
      {id: "header-search", category: "Search"},
      {id: "research-help", category: "homepage"},
      {id: "study-space", category: "homepage"},
      {id: "visit-us", category: "homepage"},
      {id: "online-support", category: "homepage"},
      {id: "books-media", category: "homepage"},
      {id: "articles", category: "homepage"},
      {id: "databases", category: "homepage"},
      {id: "research-guides", category: "homepage"},
      {id: "journal-finder", category: "homepage"},
      {id: "collections-search", category: "homepage"},
      {id: "events", category: "homepage"},
      {id: "news", category: "homepage"},
      {id: "charles-library", category: "homepage"},
      {id: "hsl", category: "homepage"},
      {id: "lcdss", category: "homepage"},
      {id: "blockson", category: "homepage"},
      {id: "scrc", category: "homepage"},
      {id: "law", category: "homepage"}
    ];

    function handleEventClicks(label, category) {
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
	  
  }, 2000);
});

$("#visitMenuButton").click(function(event) {
  event.preventDefault();
});