$(document).on('turbolinks:load', function() {
  x = $('.container.nav-container').offset();
  x2 = $('#visitMenuButton').offset();
  x3 = $('#researchMenuButton').offset();

  $("#visitMenuButton").mouseover(function() {
    $('#visit-links').css("left", x.left - x2.left);
  });

  $("#researchMenuButton").mouseover(function() {
    $('#research-links').css("left", x.left - x3.left);
  });

  $("#m_department").change(function() {
    var dept = encodeURIComponent($("#m_department").find(":selected").val());
    window.location.href = "/people?department="+dept+"&page=1";
  });
  
  $("#m_subject").change(function() {
    var subject = encodeURIComponent($("#m_subject").find(":selected").val());
    window.location.href = "/people?specialty="+subject+"&page=1";
  });

  $("#department").change(function() {
    var dept = encodeURIComponent($("#department").find(":selected").val());
    window.location.href = "/people?department="+dept+"&page=1";
  });
  
  $("#subject").change(function() {
    var subject = encodeURIComponent($("#subject").find(":selected").val());
    window.location.href = "/people?specialty="+subject+"&page=1";
  });

  $("#failover-global-search").submit(function(){
    var query = document.getElementById("failover-global-search").elements[0].value;
    var delims = "any,contains,";
    document.getElementById("failover-global-search").elements[0].style.color = "white";
    document.getElementById("failover-global-search").elements[0].value = delims+query;
  });
  $("#failover-mobile-search-form").submit(function(){
    var query = document.getElementById("failover-mobile-search-form").elements[0].value;
    var delims = "any,contains,";
    document.getElementById("failover-mobile-search-form").elements[0].style.color = "white";
    document.getElementById("failover-mobile-search-form").elements[0].value = delims+query;
  });
  $("#failover-global-mobile-search-form").submit(function(){
    var query = document.getElementById("failover-global-mobile-search-form").elements[0].value;
    var delims = "any,contains,";
    document.getElementById("failover-global-mobile-search-form").elements[0].style.color = "white";
    document.getElementById("failover-global-mobile-search-form").elements[0].value = delims+query;
  });
  $("#failover-desktop-search-form").submit(function(){
    var query = document.getElementById("failover-desktop-search-form").elements[0].value;
    var delims = "any,contains,";
    document.getElementById("failover-desktop-search-form").elements[0].style.setProperty("color", "white", "important");
    document.getElementById("failover-desktop-search-form").elements[0].value = delims+query;
  });

});

$(document).ready(function(){
  // wpvi
  $("#nav-sec21a-tab").click(function() {
    $('html, body').animate({
        scrollTop: $("#nav-tabs").offset().top
    }, 1000);
  });
  $("#nav-sec21b-tab").click(function() {
    $('html, body').animate({
        scrollTop: $("#nav-tabs").offset().top
    }, 1000);
  });
  $("#nav-sec22-tab").click(function() {
    $('html, body').animate({
        scrollTop: $("#nav-tabs").offset().top
    }, 1000);
  });
  $("#nav-sec23-tab").click(function() {
    $('html, body').animate({
        scrollTop: $("#nav-tabs").offset().top
    }, 1000);
  });
  // end wpvi

  setTimeout(function(){
    $('form#desktop-search-form').on('keypress', function (evt) {
      if (evt.keyCode == 13) {
        handleEventClicks("main-search", "Search");

      }
    });
    $('form#failover-desktop-search-form').on('keypress', function (evt) {
      if (evt.keyCode == 13) {
        handleEventClicks("main-search", "Search");

      }
    });

    $('form#global-search-form').on('keypress', function (evt) {
      if (evt.keyCode == 13) {
        handleEventClicks("header-search", "Search");
      }
    });
    $('form#failover-global-search-form').on('keypress', function (evt) {
      if (evt.keyCode == 13) {
        handleEventClicks("header-search", "Search");
      }
    });

    $('form#mobile-search-form').on('keypress', function (evt) {
      if (evt.keyCode == 13) {
        handleEventClicks("mobile-search", "Search");
      }
    });
    $('form#failover-mobile-search-form').on('keypress', function (evt) {
      if (evt.keyCode == 13) {
        handleEventClicks("mobile-search", "Search");
      }
    });
    
    $('staffSearch').on('keypress', function (evt) {
      if (evt.keyCode == 13) {
        var q = $("#staffSearch").val();
        window.location.href = "/people?q="+q+"&page=1";
      }
    });

    dc = document.querySelector('a[href="https://digital.library.temple.edu/"]');
    if(dc) dc.setAttribute("id","digcol")

    general_tracks = [
      {id: "specialist-print", category: "general"}
    ]

    home_tracks = [
      {id: "digcol", category: "Outbound Links"},
      {id: "main-search", category: "Search"},
      {id: "header-search", category: "Search"},
      {id: "research-help", category: "homepage"},
      {id: "study-space", category: "homepage"},
      {id: "printing-computing", category: "homepage"},
      {id: "online-resources", category: "homepage"},
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
      {id: "law", category: "homepage"},
      {id: "scop", category: "homepage"}
    ];

    blockson_tracks = [
      {id: "blockson_digitized_materials_button", category: "blockson"},
      {id: "blockson_hours_and_info_button", category: "blockson"},
      {id: "blockson_visit_header", category: "blockson"},
      {id: "blockson_tours_header", category: "blockson"},
      {id: "blockson_events_header", category: "blockson"},
      {id: "blockson_events_view_all", category: "blockson"},
      {id: "blockson_research_header", category: "blockson"}
    ];

    hsl_tracks = [
      {id: "hsl_ginsburg_link_button", category: "hsl"},
      {id: "hsl_podiatry_link_button", category: "hsl"},
      {id: "hsl_study_room_button", category: "hsl"},
      {id: "hsl_chat_link_button", category: "hsl"},
      {id: "hsl_appointment_link_button", category: "hsl"},
      {id: "hsl_email_link_button", category: "hsl"},
      {id: "hsl_journal_finder_button", category: "hsl"},
      {id: "hsl_support_button", category: "hsl"},
      {id: "hsl_visit_header", category: "hsl"},
      {id: "hsl_resources_header", category: "hsl"},
      {id: "hsl_research_header", category: "hsl"},
      {id: "hsl_events_header", category: "hsl"},
      {id: "hsl_events_view_all", category: "hsl"},
      {id: "hsl_resources_view_all", category: "hsl"}
    ];

    scop_tracks = [
      {id: "scop_scholar_share_button", category: "scop"},
      {id: "scop_nb_press_button", category: "scop"},
      {id: "scop_open_journals_button", category: "scop"},
      {id: "scop_contact_button", category: "scop"},
      {id: "scop_pub_services_header", category: "scop"},
      {id: "scop_scholar_share_header", category: "scop"},
      {id: "scop_events_header", category: "scop"},
      {id: "scop_events_view_all", category: "scop"},
      {id: "scop_blog_header", category: "scop"},
      {id: "scop_blog_view_all", category: "scop"}
    ];

    scrc_tracks = [
      {id: "scrc_reading_room_button", category: "scrc"},
      {id: "scrc_finding_aids_button", category: "scrc"},
      {id: "scrc_materials_button", category: "scrc"},
      {id: "scrc_contact_button", category: "scrc"},
      {id: "scrc_search_button", category: "scrc"},
      {id: "scrc_info_button", category: "scrc"},
      {id: "scrc_visit_header", category: "scrc"},
      {id: "scrc_emphases_header", category: "scrc"}
    ];

    tudsc_tracks = [
      {id: "lcdss_makerspace_button", category: "lcdss"},
      {id: "lcdss_vr_studio_button", category: "lcdss"},
      {id: "lcdss_innovation_lab_button", category: "lcdss"},
      {id: "lcdss_newsletter_button", category: "lcdss"},
      {id: "lcdss_staff_link_button", category: "lcdss"},
      {id: "lcdss_visit_header", category: "lcdss"},
      {id: "lcdss_research_header", category: "lcdss"},
      {id: "lcdss_events_header", category: "lcdss"},
      {id: "lcdss_blog_header", category: "lcdss"},
      {id: "lcdss_blog_view_all", category: "lcdss"}
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

    general_tracks.forEach((track) => {
      if(track.id) {
        if (el = document.getElementById(track.id)) {
          el.addEventListener("click", () => {
            handleEventClicks(track.id, track.category)
          });
        };
      }
    });

    home_tracks.forEach((track) => {
      if(track.id) {
        if (el = document.getElementById(track.id)) {
          el.addEventListener("click", () => {
            handleEventClicks(track.id, track.category)
          });
        };
      }
    });

    blockson_tracks.forEach((track) => {
      if(track.id) {
        if (el = document.getElementById(track.id)) {
          el.addEventListener("click", () => {
            handleEventClicks(track.id, track.category)
          });
        };
      }
    });

    hsl_tracks.forEach((track) => {
      if(track.id) {
        if (el = document.getElementById(track.id)) {
          el.addEventListener("click", () => {
            handleEventClicks(track.id, track.category)
          });
        };
      }
    });

    scop_tracks.forEach((track) => {
      if(track.id) {
        if (el = document.getElementById(track.id)) {
          el.addEventListener("click", () => {
            handleEventClicks(track.id, track.category)
          });
        };
      }
    });

    scrc_tracks.forEach((track) => {
      if(track.id) {
        if (el = document.getElementById(track.id)) {
          el.addEventListener("click", () => {
            handleEventClicks(track.id, track.category)
          });
        };
      }
    });

    tudsc_tracks.forEach((track) => {
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
