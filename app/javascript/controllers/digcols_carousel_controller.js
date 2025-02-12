import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {

  connect() {
    var multipleCardCarousel = document.querySelector(
      "#digcolsCarousel"
    );
    if (window.matchMedia("(min-width: 768px)").matches) {
      
      var carousel = new bootstrap.Carousel(multipleCardCarousel, {
        "bs-pause": true,
        "bs-wrap": true,
        "bs-interval": false
      });

      carousel.pause();

      var carouselWidth = $("#digcolsCarousel .carousel-inner")[0].scrollWidth;
      var cardWidth = $("#digcolsCarousel .carousel-item").width();
      var scrollPosition = 0;

      $("#digcolsCarousel .carousel-control-next").on("click", function () {
        if (scrollPosition < carouselWidth - cardWidth * 4) {
          scrollPosition += cardWidth;
          $("#digcolsCarousel .carousel-inner").animate(
            { scrollLeft: scrollPosition },
            600
          );
        }
      });

      $("#digcolsCarousel .carousel-control-prev").on("click", function () {
        if (scrollPosition > 0) {
          scrollPosition -= cardWidth;
          $("#digcolsCarousel .carousel-inner").animate(
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
