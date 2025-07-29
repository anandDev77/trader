/**
 * Add Stock page JavaScript functionality
 * Handles form validation, dynamic button updates, and accessibility features
 */

(function() {
  'use strict';

  // DOM elements
  const addStockForm = document.getElementById('addStockForm');
  const buyAction = document.getElementById('buyAction');
  const sellAction = document.getElementById('sellAction');
  const addStockButton = document.getElementById('addStockButton');
  const addStockButtonText = document.getElementById('addStockButtonText');
  const addStockButtonSpinner = document.getElementById('addStockButtonSpinner');
  const submitStatus = document.getElementById('submit-status');

  // Initialize when DOM is ready
  document.addEventListener('DOMContentLoaded', function() {
    initializeFormValidation();
    initializeDynamicButtonUpdates();
    initializeLoadingStates();
    initializeAccessibilityFeatures();
  });

  /**
   * Initialize Bootstrap form validation
   */
  function initializeFormValidation() {
    if (!addStockForm) return;

    // Prevent form submission if validation fails
    addStockForm.addEventListener('submit', function(event) {
      if (!addStockForm.checkValidity()) {
          event.preventDefault();
          event.stopPropagation();
        
        // Announce validation error to screen readers
        announceToScreenReader('Please fix the form errors before submitting.');
      } else {
        // Show loading state
        setLoadingState(true);
        announceToScreenReader('Submitting stock transaction...');
      }
      
      addStockForm.classList.add('was-validated');
    }, false);

    // Real-time validation feedback
    const inputs = addStockForm.querySelectorAll('input[required], select[required]');
    inputs.forEach(input => {
      input.addEventListener('blur', function() {
        validateField(input);
      });
      
      input.addEventListener('input', function() {
        // Clear validation state on input
        if (input.classList.contains('is-valid') || input.classList.contains('is-invalid')) {
          input.classList.remove('is-valid', 'is-invalid');
        }
      });
    });
  }

  /**
   * Initialize dynamic button updates based on transaction type
   */
  function initializeDynamicButtonUpdates() {
    if (!buyAction || !sellAction || !addStockButtonText) return;

    function updateButtonLabel() {
      const isSell = sellAction.checked;
      
      if (isSell) {
        addStockButtonText.innerHTML = '<i class="bi bi-arrow-down-circle me-2" aria-hidden="true"></i>Sell Stock';
        addStockButton.classList.remove('btn-primary');
        addStockButton.classList.add('btn-danger');
        announceToScreenReader('Sell stock mode selected');
      } else {
        addStockButtonText.innerHTML = '<i class="bi bi-arrow-up-circle me-2" aria-hidden="true"></i>Buy Stock';
        addStockButton.classList.remove('btn-danger');
        addStockButton.classList.add('btn-primary');
        announceToScreenReader('Buy stock mode selected');
      }
    }

    // Add event listeners for radio button changes
    buyAction.addEventListener('change', updateButtonLabel);
    sellAction.addEventListener('change', updateButtonLabel);
    
    // Initialize button label
    updateButtonLabel();
  }

  /**
   * Initialize loading states
   */
  function initializeLoadingStates() {
    if (!addStockForm) return;

    // Reset loading state on page load
    setLoadingState(false);
    
    // Handle form submission timeout
    addStockForm.addEventListener('submit', function() {
      // Set a timeout to show loading state for at least 500ms
      setTimeout(() => {
        if (addStockButton && addStockButton.disabled) {
          announceToScreenReader('Stock transaction is taking longer than expected. Please wait.');
        }
      }, 500);
    });
  }

  /**
   * Initialize accessibility features
   */
  function initializeAccessibilityFeatures() {
    // Add live region for dynamic content
    const liveRegion = document.createElement('div');
    liveRegion.setAttribute('aria-live', 'polite');
    liveRegion.setAttribute('aria-atomic', 'true');
    liveRegion.className = 'sr-only';
    liveRegion.id = 'addStock-live-region';
    document.body.appendChild(liveRegion);

    // Announce page load to screen readers
    announceToScreenReader('Add stock page loaded. Select buy or sell mode and enter stock details.');
  }

  /**
   * Set loading state for the submit button
   * @param {boolean} isLoading - Whether to show loading state
   */
  function setLoadingState(isLoading) {
    if (!addStockButton || !addStockButtonText || !addStockButtonSpinner) return;

    if (isLoading) {
      addStockButton.disabled = true;
      addStockButtonText.classList.add('d-none');
      addStockButtonSpinner.classList.remove('d-none');
      addStockButton.setAttribute('aria-busy', 'true');
    } else {
      addStockButton.disabled = false;
      addStockButtonText.classList.remove('d-none');
      addStockButtonSpinner.classList.add('d-none');
      addStockButton.setAttribute('aria-busy', 'false');
    }
  }

  /**
   * Validate a single form field
   * @param {HTMLElement} field - The input field to validate
   */
  function validateField(field) {
    if (!field) return;

    const isValid = field.checkValidity();
    
    if (isValid) {
      field.classList.remove('is-invalid');
      field.classList.add('is-valid');
    } else {
      field.classList.remove('is-valid');
      field.classList.add('is-invalid');
    }
  }

  /**
   * Announce message to screen readers
   * @param {string} message - Message to announce
   */
  function announceToScreenReader(message) {
    const liveRegion = document.getElementById('addStock-live-region');
    if (liveRegion) {
      liveRegion.textContent = message;
      // Clear message after a short delay
      setTimeout(() => {
        liveRegion.textContent = '';
      }, 3000);
    }

    // Also update the submit status if available
    if (submitStatus) {
      submitStatus.textContent = message;
      setTimeout(() => {
        submitStatus.textContent = '';
      }, 3000);
    }
  }

  /**
   * Handle form submission errors
   * @param {string} errorMessage - Error message to display
   */
  function handleSubmissionError(errorMessage) {
    setLoadingState(false);
    announceToScreenReader('Transaction failed. ' + errorMessage);
    
    // Show error alert
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-danger mt-3';
    alertDiv.setAttribute('role', 'alert');
    alertDiv.innerHTML = `
      <i class="bi bi-exclamation-triangle-fill me-2" aria-hidden="true"></i>
      ${errorMessage}
    `;
    
    if (addStockForm) {
      addStockForm.appendChild(alertDiv);
      
      // Remove alert after 5 seconds
      setTimeout(() => {
        if (alertDiv.parentNode) {
          alertDiv.remove();
    }
      }, 5000);
    }
  }

  // Global error handler for this page
  window.addEventListener('error', function(event) {
    console.error('Add Stock page error:', event.error);
    handleSubmissionError('An unexpected error occurred. Please try again.');
  });

  // Handle network errors
  window.addEventListener('offline', function() {
    handleSubmissionError('No internet connection. Please check your network and try again.');
  });

  // Export functions for testing (if needed)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
      initializeFormValidation,
      initializeDynamicButtonUpdates,
      initializeLoadingStates,
      initializeAccessibilityFeatures,
      setLoadingState,
      validateField,
      announceToScreenReader,
      handleSubmissionError
    };
  }
})();
