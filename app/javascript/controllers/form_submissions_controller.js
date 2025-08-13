import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-submissions"
// Shared controller for both av-requests and copy-requests forms
export default class extends Controller {
  static targets = ["addBtn", "removeBtn", "container"]
  static values = { 
    formType: String,
    maxRequests: { type: Number, default: 10 }
  }
  
  connect() {
    console.log(`Form Submissions controller connected for ${this.formTypeValue} form`)
    
    this.currentRequestCount = 1
    
    // Add form validation if this is a copy-requests form
    if (this.formTypeValue === 'copy-requests') {
      this.element.closest('form').addEventListener('submit', this.validatePricingOptions.bind(this))
    }
  }

  addRequest() {
    console.log("Add request button clicked")
    
    if (this.currentRequestCount < this.maxRequestsValue) {
      const nextGroup = this.containerTarget.querySelector(`[data-index="${this.currentRequestCount}"]`)
      
      if (nextGroup) {
        nextGroup.style.display = 'block'
        this.currentRequestCount++
        
        // Show remove button if we have more than 1 group
        if (this.currentRequestCount > 1) {
          this.removeBtnTarget.style.display = 'inline-block'
        }
        
        // Hide add button if we've reached the max
        if (this.currentRequestCount >= this.maxRequestsValue) {
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
          if (input.type === 'checkbox') {
            input.checked = false
          }
        })
      }
      
      // Hide remove button if we're back to 1 group
      if (this.currentRequestCount <= 1) {
        this.removeBtnTarget.style.display = 'none'
      }
      
      // Show add button if we're below max
      if (this.currentRequestCount < this.maxRequestsValue) {
        this.addBtnTarget.style.display = 'inline-block'
      }
    }
  }
  
  // Validation method for copy-requests forms only
  validatePricingOptions(event) {
    if (this.formTypeValue !== 'copy-requests') {
      return true
    }
    
    // Check each visible request group for at least one selected pricing option
    const visibleGroups = this.containerTarget.querySelectorAll('.request-group[style*="display: block"], .request-group:not([style*="display: none"])')
    
    for (let i = 0; i < visibleGroups.length; i++) {
      const group = visibleGroups[i]
      const requestIndex = group.dataset.index
      const pricingOptions = group.querySelectorAll('.pricing-option:checked')
      
      if (pricingOptions.length === 0) {
        event.preventDefault()
        alert(`Please select at least one pricing option for Request ${parseInt(requestIndex) + 1}.`)
        
        // Scroll to the problematic request group
        group.scrollIntoView({ behavior: 'smooth', block: 'center' })
        
        return false
      }
    }
    
    return true
  }
}
