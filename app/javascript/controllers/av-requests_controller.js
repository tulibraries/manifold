import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="av-requests"
export default class extends Controller {
  static targets = ["addBtn", "removeBtn", "container"]
  
  connect() {
    console.log("AV Requests controller connected")
    
    this.currentRequestCount = 1
    this.maxRequests = 10
  }

  addRequest() {
    console.log("Add request button clicked")
    
    if (this.currentRequestCount < this.maxRequests) {
      const nextGroup = this.containerTarget.querySelector(`[data-index="${this.currentRequestCount}"]`)
      
      if (nextGroup) {
        nextGroup.style.display = 'block'
        this.currentRequestCount++
        
        // Show remove button if we have more than 1 group
        if (this.currentRequestCount > 1) {
          this.removeBtnTarget.style.display = 'inline-block'
        }
        
        // Hide add button if we've reached the max
        if (this.currentRequestCount >= this.maxRequests) {
          this.addBtnTarget.style.display = 'none'
        }
        
        // Scroll to the new group
        nextGroup.scrollIntoView({ behavior: 'smooth', block: 'center' })
      } else {
        console.log("No next group found")
      }
    } else {
      console.log("Already at max requests")
    }
  }

  removeRequest() {
    if (this.currentRequestCount > 1) {
      this.currentRequestCount--
      const groupToHide = this.containerTarget.querySelector(`[data-index="${this.currentRequestCount}"]`)
      if (groupToHide) {
        groupToHide.style.display = 'none'
        
        // Clear all input values in the hidden group
        const inputs = groupToHide.querySelectorAll('input, textarea, select')
        inputs.forEach(input => {
          input.value = ''
        })
      }
      
      // Hide remove button if we're back to 1 group
      if (this.currentRequestCount <= 1) {
        this.removeBtnTarget.style.display = 'none'
      }
      
      // Show add button if we're below max
      if (this.currentRequestCount < this.maxRequests) {
        this.addBtnTarget.style.display = 'inline-block'
      }
    }
  }
}
