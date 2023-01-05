import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    var el = "";
    var dc = document.querySelector('a[href="https://digital.library.temple.edu/"]');
    if(dc) dc.setAttribute("id","digcol");

    var general_tracks = [
      {id: "specialist-print", category: "general"}
    ]

    var home_tracks = [
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

    var blockson_tracks = [
      {id: "blockson_digitized_materials_button", category: "blockson"},
      {id: "blockson_hours_and_info_button", category: "blockson"},
      {id: "blockson_visit_header", category: "blockson"},
      {id: "blockson_tours_header", category: "blockson"},
      {id: "blockson_events_header", category: "blockson"},
      {id: "blockson_events_view_all", category: "blockson"},
      {id: "blockson_research_header", category: "blockson"}
    ];

    var hsl_tracks = [
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

    var scop_tracks = [
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

    var scrc_tracks = [
      {id: "scrc_reading_room_button", category: "scrc"},
      {id: "scrc_finding_aids_button", category: "scrc"},
      {id: "scrc_materials_button", category: "scrc"},
      {id: "scrc_contact_button", category: "scrc"},
      {id: "scrc_search_button", category: "scrc"},
      {id: "scrc_info_button", category: "scrc"},
      {id: "scrc_visit_header", category: "scrc"},
      {id: "scrc_emphases_header", category: "scrc"}
    ];

    var tudsc_tracks = [
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
        console.log("ga defined")
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
  }

}