import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.carouselInner = this.element.querySelector(".carousel-inner")
    this.nextButton = this.element.querySelector(".carousel-control-next")
    this.prevButton = this.element.querySelector(".carousel-control-prev")
    this.card = this.element.querySelector(".carousel-item")

    if (!this.carouselInner || !this.nextButton || !this.prevButton || !this.card) {
      return
    }

    this.handleNext = (event) => {
      event.preventDefault()
      event.stopPropagation()

      const nextPosition = Math.min(
        this.carouselInner.scrollLeft + this.card.offsetWidth,
        this.maxScroll()
      )

      $(this.carouselInner).animate({ scrollLeft: nextPosition }, 600)
    }

    this.handlePrev = (event) => {
      event.preventDefault()
      event.stopPropagation()

      const nextPosition = Math.max(
        this.carouselInner.scrollLeft - this.card.offsetWidth,
        0
      )

      $(this.carouselInner).animate({ scrollLeft: nextPosition }, 600)
    }

    $(this.nextButton).on("click", this.handleNext)
    $(this.prevButton).on("click", this.handlePrev)
  }

  disconnect() {
    if (this.nextButton && this.handleNext) {
      $(this.nextButton).off("click", this.handleNext)
    }

    if (this.prevButton && this.handlePrev) {
      $(this.prevButton).off("click", this.handlePrev)
    }
  }

  maxScroll() {
    return Math.max(0, this.carouselInner.scrollWidth - this.carouselInner.clientWidth)
  }
}
