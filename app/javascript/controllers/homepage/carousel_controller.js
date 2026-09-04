import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.carouselInner = this.element.querySelector(".carousel-inner")
    this.nextButton = this.element.querySelector(".carousel-control-next")
    this.prevButton = this.element.querySelector(".carousel-control-prev")
    this.card = this.element.querySelector(".carousel-item")
    this.status = this.element.querySelector(".carousel-status")

    if (!this.carouselInner || !this.nextButton || !this.prevButton) return

    if (!this.card) {
      this.nextButton.disabled = true
      this.prevButton.disabled = true
      return
    }

    this.isAnimating = false
    this.carouselInner.scrollLeft = 0
    this.cards().forEach((card, index) => {
      if (!card.dataset.carouselIndex) card.dataset.carouselIndex = index + 1
    })
    this.updateControls()
    this.observeResize()

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
        this.announcePosition()
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
        this.announcePosition()
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
    this.resizeObserver?.disconnect()

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

  cards() {
    return Array.from(this.carouselInner.children)
  }

  updateControls() {
    const disabled = !this.canScroll()
    this.nextButton.disabled = disabled
    this.prevButton.disabled = disabled
  }

  observeResize() {
    if (!window.ResizeObserver) return

    this.resizeObserver = new ResizeObserver(() => this.updateControls())
    this.resizeObserver.observe(this.carouselInner)
  }

  announcePosition() {
    if (!this.status) return

    const currentCard = this.carouselInner.firstElementChild
    const position = currentCard.dataset.carouselIndex
    this.status.textContent = `Showing item ${position} of ${this.cards().length}.`
  }
}
