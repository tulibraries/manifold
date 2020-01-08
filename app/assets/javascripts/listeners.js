$(document).ready(function(){

  el = document.querySelector('a[href="https://digital.library.temple.edu/"]');
  if(el) el.setAttribute("id","digcol")

	var tracks = [
		{id: "Digital Collections", category: "Outbound Links"}
	];

  function handleEventClicks(track) {
    if (typeof ga != "undefined") {
      ga('send', 'event', {
        eventCategory: track.category,
        eventAction: 'click',
        eventLabel: track.id,
        forceSSL: true,
        anonymizeIp: true
      });
    }
  }

  tracks.forEach(function(track) {
    if (el == document.getElementById('digcol')) {
      el.addEventListener("click", function(){
        handleEventClicks(track);
      });
    }
  });

});
