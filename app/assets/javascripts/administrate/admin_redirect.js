
$(document).ready(function() {  
  const queryString = window.location.search
  const path = window.location.pathname
  const urlParams = new URLSearchParams(queryString);
  
  if (urlParams.get('admin') == "show" || urlParams.get('admin') == "index") {
    window.location.href = path;
  }
});