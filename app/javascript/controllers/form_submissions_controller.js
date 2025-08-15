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
    
    // Add form submission validation
    this.setupFormValidation()
    
    // Don't set required attributes for the first group - it uses HTML validation
    // Only manage JS validation for groups 2-10 (data-index 1-9)
    
    // Add red asterisks to required field labels (skip first group)
    this.updateRequiredLabels()
  }

  addRequest() {
    console.log("Add request button clicked")
    
    if (this.currentRequestCount < this.maxRequestsValue) {
      const nextGroup = this.containerTarget.querySelector(`[data-index="${this.currentRequestCount}"]`)
      
      if (nextGroup) {
        nextGroup.style.display = 'block'
        
        // Set required attributes for visible fields based on form type
        this.setRequiredFieldsForGroup(nextGroup, true)
        
        // Update required labels for the new group
        this.updateRequiredLabels()
        
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
        
        // Update required labels after hiding group
        this.updateRequiredLabels()
        
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
      // For copy-requests: format, box, folder, and estimated_pages should be required when visible
      const formatSelect = group.querySelector('select[name*="format_"]')
      const boxInput = group.querySelector('input[name*="box"]')
      const folderInput = group.querySelector('input[name*="folder"]')
      const estimatedPagesInput = group.querySelector('input[name*="estimated_pages"]')
      
      if (formatSelect) {
        formatSelect.required = isVisible
      }
      if (boxInput) {
        boxInput.required = isVisible
      }
      if (folderInput) {
        folderInput.required = isVisible
      }
      if (estimatedPagesInput) {
        estimatedPagesInput.required = isVisible
      }
    }
  }
  
  // Setup form submission validation
  setupFormValidation() {
    const form = this.element.closest('form')
    if (form) {
      form.addEventListener('submit', (event) => {
        if (!this.validateForm()) {
          event.preventDefault()
          this.highlightInvalidFields()
          this.scrollToFirstError()
        }
      })
      
      // Add real-time validation to clear errors when fields are filled
      this.setupRealTimeValidation()
    }
  }
  
  // Setup real-time validation to clear errors as user types
  setupRealTimeValidation() {
    this.containerTarget.addEventListener('input', (event) => {
      const field = event.target
      if (field.required && field.classList.contains('is-invalid')) {
        if (field.value && field.value.trim() !== '') {
          // Clear error styling for this field
          field.classList.remove('is-invalid')
          field.style.borderColor = ''
          field.style.boxShadow = ''
          
          // Reset label color
          const wrapper = field.closest('.mb-3, .form-group')
          if (wrapper) {
            const label = wrapper.querySelector('label')
            if (label) {
              label.style.color = ''
            }
          }
        }
      }
    })
    
    this.containerTarget.addEventListener('change', (event) => {
      const field = event.target
      if (field.required && field.classList.contains('is-invalid')) {
        if (field.value && field.value.trim() !== '') {
          // Clear error styling for this field
          field.classList.remove('is-invalid')
          field.style.borderColor = ''
          field.style.boxShadow = ''
          
          // Reset label color
          const wrapper = field.closest('.mb-3, .form-group')
          if (wrapper) {
            const label = wrapper.querySelector('label')
            if (label) {
              label.style.color = ''
            }
          }
        }
      }
    })
  }
  
  // Validate all visible required fields (HTML handles first group, JS handles groups 2-10)
  validateForm() {
    // Let HTML validation handle the first group (data-index="0")
    // Only check JS-managed groups (data-index 1-9)
    const jsValidatedGroups = this.containerTarget.querySelectorAll('.request-group:not([style*="display: none"]):not([data-index="0"])')
    let isValid = true
    
    jsValidatedGroups.forEach(group => {
      const requiredFields = group.querySelectorAll('[required]')
      requiredFields.forEach(field => {
        if (!field.value || field.value.trim() === '') {
          isValid = false
        }
      })
    })
    
    return isValid
  }
  
  // Highlight invalid fields with red border and error styling (skip first group - HTML handles it)
  highlightInvalidFields() {
    // Clear previous error styles for JS-managed groups only
    this.clearErrorStyles()
    
    // Only highlight JS-managed groups (data-index 1-9), let HTML handle first group
    const jsValidatedGroups = this.containerTarget.querySelectorAll('.request-group:not([style*="display: none"]):not([data-index="0"])')
    
    jsValidatedGroups.forEach(group => {
      const requiredFields = group.querySelectorAll('[required]')
      requiredFields.forEach(field => {
        if (!field.value || field.value.trim() === '') {
          // Add error styling to the field
          field.classList.add('is-invalid')
          field.style.borderColor = '#dc3545'
          field.style.boxShadow = '0 0 0 0.2rem rgba(220, 53, 69, 0.25)'
          
          // Find and highlight the label
          const wrapper = field.closest('.mb-3, .form-group')
          if (wrapper) {
            const label = wrapper.querySelector('label')
            if (label) {
              label.style.color = '#dc3545'
            }
          }
        }
      })
    })
  }
  
  // Clear all error styling (only for JS-managed groups)
  clearErrorStyles() {
    const jsValidatedGroups = this.containerTarget.querySelectorAll('.request-group:not([data-index="0"])')
    jsValidatedGroups.forEach(group => {
      const allFields = group.querySelectorAll('input, select, textarea')
      allFields.forEach(field => {
        field.classList.remove('is-invalid')
        field.style.borderColor = ''
        field.style.boxShadow = ''
        
        // Reset label colors
        const wrapper = field.closest('.mb-3, .form-group')
        if (wrapper) {
          const label = wrapper.querySelector('label')
          if (label) {
            label.style.color = ''
          }
        }
      })
    })
  }
  
  // Scroll to the first error field
  scrollToFirstError() {
    const firstErrorField = this.containerTarget.querySelector('.is-invalid')
    if (firstErrorField) {
      firstErrorField.scrollIntoView({ 
        behavior: 'smooth', 
        block: 'center' 
      })
      firstErrorField.focus()
    }
  }
  
  // Add red asterisks to required field labels (skip first group which uses HTML validation)
  updateRequiredLabels() {
    // Remove existing JS-added asterisks first
    this.containerTarget.querySelectorAll('.required-asterisk').forEach(asterisk => {
      asterisk.remove()
    })
    
    // Add asterisks to currently visible required fields (skip data-index="0")
    const visibleGroups = this.containerTarget.querySelectorAll('.request-group:not([style*="display: none"]):not([data-index="0"])')
    
    visibleGroups.forEach(group => {
      const requiredFields = group.querySelectorAll('[required]')
      requiredFields.forEach(field => {
        const wrapper = field.closest('.mb-3, .form-group')
        if (wrapper) {
          const label = wrapper.querySelector('label')
          if (label && !label.querySelector('.required-asterisk')) {
            const asterisk = document.createElement('span')
            asterisk.textContent = ' *'
            asterisk.className = 'required-asterisk'
            asterisk.style.color = '#dc3545'
            asterisk.style.fontWeight = 'bold'
            label.appendChild(asterisk)
          }
        }
      })
    })
  }
}
