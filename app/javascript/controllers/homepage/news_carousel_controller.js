import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    var multipleCardCarousel = document.querySelector("#newsCarousel")
    var carousel = new bootstrap.Carousel(multipleCardCarousel, {
      "bs-pause": true,
      "bs-wrap": true,
      "bs-interval": false
    })

    carousel.pause()

    var carouselInner = $("#newsCarousel .carousel-inner")[0]
    var cardWidth = $("#newsCarousel .carousel-item").width()

    function maxScroll() {
      return Math.max(0, carouselInner.scrollWidth - carouselInner.clientWidth)
    }

    $("#newsCarousel .carousel-control-next").on("click", function(event) {
      event.preventDefault()
      event.stopPropagation()
      var nextPosition = Math.min(carouselInner.scrollLeft + cardWidth, maxScroll())
      $("#newsCarousel .carousel-inner").animate(
        { scrollLeft: nextPosition },
        600
      )
    })

    $("#newsCarousel .carousel-control-prev").on("click", function(event) {
      event.preventDefault()
      event.stopPropagation()
      var nextPosition = Math.max(carouselInner.scrollLeft - cardWidth, 0)
      $("#newsCarousel .carousel-inner").animate(
        { scrollLeft: nextPosition },
        600
      )
    })
  }
}
