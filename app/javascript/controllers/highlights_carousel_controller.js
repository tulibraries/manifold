import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {

  connect() {
    var multipleCardCarousel = document.querySelector(
      "#highlightsCarousel"
    );
    var carousel = new bootstrap.Carousel(multipleCardCarousel, {
      "bs-pause": true,
      "bs-wrap": true,
      "bs-interval": false
    });

    carousel.pause();

    var carouselInner = $("#highlightsCarousel .carousel-inner")[0];
    var cardWidth = $("#highlightsCarousel .carousel-item").width();

    function maxScroll() {
      return Math.max(0, carouselInner.scrollWidth - carouselInner.clientWidth);
    }

    $("#highlightsCarousel .carousel-control-next").on("click", function (event) {
      event.preventDefault();
      event.stopPropagation();
      var nextPosition = Math.min(carouselInner.scrollLeft + cardWidth, maxScroll());
      $("#highlightsCarousel .carousel-inner").animate(
        { scrollLeft: nextPosition },
        600
      );
    });

    $("#highlightsCarousel .carousel-control-prev").on("click", function (event) {
      event.preventDefault();
      event.stopPropagation();
      var nextPosition = Math.max(carouselInner.scrollLeft - cardWidth, 0);
      $("#highlightsCarousel .carousel-inner").animate(
        { scrollLeft: nextPosition },
        600
      );
    });

  }
}
