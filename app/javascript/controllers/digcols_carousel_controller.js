import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {

  connect() {
    var multipleCardCarousel = document.querySelector(
      "#digcolsCarousel"
    );
    
    var carousel = new bootstrap.Carousel(multipleCardCarousel, {
      "bs-pause": true,
      "bs-wrap": true,
      "bs-interval": false
    });

    carousel.pause();

    var carouselInner = $("#digcolsCarousel .carousel-inner")[0];
    var cardWidth = $("#digcolsCarousel .carousel-item").width();

    function maxScroll() {
      return Math.max(0, carouselInner.scrollWidth - carouselInner.clientWidth);
    }

    $("#digcolsCarousel .carousel-control-next").on("click", function (event) {
      event.preventDefault();
      event.stopPropagation();
      var nextPosition = Math.min(carouselInner.scrollLeft + cardWidth, maxScroll());
      $("#digcolsCarousel .carousel-inner").animate(
        { scrollLeft: nextPosition },
        600
      );
    });

    $("#digcolsCarousel .carousel-control-prev").on("click", function (event) {
      event.preventDefault();
      event.stopPropagation();
      var nextPosition = Math.max(carouselInner.scrollLeft - cardWidth, 0);
      $("#digcolsCarousel .carousel-inner").animate(
        { scrollLeft: nextPosition },
        600
      );
    });

  }
}
