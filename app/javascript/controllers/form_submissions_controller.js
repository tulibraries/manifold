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
  }

  addRequest() {
    console.log("Add request button clicked")
    
    if (this.currentRequestCount < this.maxRequestsValue) {
      const nextGroup = this.containerTarget.querySelector(`[data-index="${this.currentRequestCount}"]`)
      
      if (nextGroup) {
        nextGroup.style.display = 'block'
        
        // Set required attributes for visible fields based on form type
        this.setRequiredFieldsForGroup(nextGroup, true)
        
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
        
        // Remove required attributes from fields when hiding
        this.setRequiredFieldsForGroup(groupToHide, false)
        
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
  
  // Helper method to set required fields based on form type and visibility
  setRequiredFieldsForGroup(group, isVisible) {
    if (this.formTypeValue === 'av-requests') {
      // For av-requests: format field should be required when visible
      const formatSelect = group.querySelector('select[name*="format_"]')
      if (formatSelect) {
        formatSelect.required = isVisible
      }
    } else if (this.formTypeValue === 'copy-requests') {
      // For copy-requests: format field should be required when visible
      const formatSelect = group.querySelector('select[name*="format_"]')
      if (formatSelect) {
        formatSelect.required = isVisible
      }
      // Note: box, folder, and estimated_pages are not required in hidden sections
      // but could be made required here if needed by the business logic
    }
  }
}
