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

    this.isAnimating = false
    this.carouselInner.scrollLeft = 0

    this.handleNext = (event) => {
      event.preventDefault()
      event.stopPropagation()

      if (!this.canScroll() || this.isAnimating) return

      this.isAnimating = true
      const nextPosition = this.card.offsetWidth

      $(this.carouselInner).animate({ scrollLeft: nextPosition }, 600, () => {
        this.carouselInner.append(this.carouselInner.firstElementChild)
        this.carouselInner.scrollLeft = 0
        this.isAnimating = false
      })
    }

    this.handlePrev = (event) => {
      event.preventDefault()
      event.stopPropagation()

      if (!this.canScroll() || this.isAnimating) return

      this.isAnimating = true
      this.carouselInner.prepend(this.carouselInner.lastElementChild)
      this.carouselInner.scrollLeft = this.card.offsetWidth

      $(this.carouselInner).animate({ scrollLeft: 0 }, 600, () => {
        this.isAnimating = false
      })
    }

    $(this.nextButton).on("click", this.handleNext)
    $(this.prevButton).on("click", this.handlePrev)
  }

  disconnect() {
    if (!this.carouselInner) return

    $(this.carouselInner).stop(true)
    this.carouselInner.scrollLeft = 0
    this.isAnimating = false

    if (this.nextButton && this.handleNext) {
      $(this.nextButton).off("click", this.handleNext)
    }

    if (this.prevButton && this.handlePrev) {
      $(this.prevButton).off("click", this.handlePrev)
    }
  }

  canScroll() {
    return this.carouselInner.scrollWidth > this.carouselInner.clientWidth
  }
}
