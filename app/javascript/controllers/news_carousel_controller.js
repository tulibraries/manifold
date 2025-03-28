import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {

  connect() {
    var multipleCardCarousel = document.querySelector(
      "#newsCarousel"
    );
    if (window.matchMedia("(min-width: 768px)").matches) {

      var carousel = new bootstrap.Carousel(multipleCardCarousel, {
        "bs-pause": true,
        "bs-wrap": true,
        "bs-interval": false
      });

      carousel.pause();

      var carouselWidth = $("#newsCarousel .carousel-inner")[0].scrollWidth;
      var cardWidth = $("#newsCarousel .carousel-item").width();
      var scrollPosition = 0;

      $("#newsCarousel .carousel-control-next").on("click", function () {
        if (scrollPosition < carouselWidth - cardWidth * 4) {
          scrollPosition += cardWidth;
          $("#newsCarousel .carousel-inner").animate(
            { scrollLeft: scrollPosition },
            600
          );
        }
      });

      $("#newsCarousel .carousel-control-prev").on("click", function () {
        if (scrollPosition > 0) {
          scrollPosition -= cardWidth;
          $("#newsCarousel .carousel-inner").animate(
            { scrollLeft: scrollPosition },
            600
          );
        }
      });

    } else {
      $(multipleCardCarousel).addClass("slide");
    }

  }
}
