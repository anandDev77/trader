/**
 * Add Portfolio page JavaScript functionality
 * Handles form validation, loading states, and accessibility features
 */

(function() {
  'use strict';

  // DOM elements
  const addPortfolioForm = document.getElementById('addPortfolioForm');
  const addPortfolioButton = document.getElementById('addPortfolioButton');
  const addPortfolioButtonText = document.getElementById('addPortfolioButtonText');
  const addPortfolioButtonSpinner = document.getElementById('addPortfolioButtonSpinner');
  const submitStatus = document.getElementById('submit-status');

  // Initialize when DOM is ready
  document.addEventListener('DOMContentLoaded', function() {
    initializeFormValidation();
    initializeLoadingStates();
    initializeAccessibilityFeatures();
  });

  /**
   * Initialize Bootstrap form validation
   */
  function initializeFormValidation() {
    if (!addPortfolioForm) return;

    // Prevent form submission if validation fails
    addPortfolioForm.addEventListener('submit', function(event) {
      if (!addPortfolioForm.checkValidity()) {
          event.preventDefault();
          event.stopPropagation();
        
        // Announce validation error to screen readers
        announceToScreenReader('Please fix the form errors before submitting.');
      } else {
        // Show loading state
        setLoadingState(true);
        announceToScreenReader('Creating portfolio...');
      }
      
      addPortfolioForm.classList.add('was-validated');
    }, false);

    // Real-time validation feedback
    const inputs = addPortfolioForm.querySelectorAll('input[required], select[required]');
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
   * Initialize loading states
   */
  function initializeLoadingStates() {
    if (!addPortfolioForm) return;

    // Reset loading state on page load
    setLoadingState(false);
    
    // Handle form submission timeout
    addPortfolioForm.addEventListener('submit', function() {
      // Set a timeout to show loading state for at least 500ms
      setTimeout(() => {
        if (addPortfolioButton && addPortfolioButton.disabled) {
          announceToScreenReader('Portfolio creation is taking longer than expected. Please wait.');
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
    liveRegion.id = 'addPortfolio-live-region';
    document.body.appendChild(liveRegion);

    // Announce page load to screen readers
    announceToScreenReader('Add portfolio page loaded. Enter portfolio owner name, initial balance, and select currency.');
  }

  /**
   * Set loading state for the submit button
   * @param {boolean} isLoading - Whether to show loading state
   */
  function setLoadingState(isLoading) {
    if (!addPortfolioButton || !addPortfolioButtonText || !addPortfolioButtonSpinner) return;

    if (isLoading) {
      addPortfolioButton.disabled = true;
      addPortfolioButtonText.classList.add('d-none');
      addPortfolioButtonSpinner.classList.remove('d-none');
      addPortfolioButton.setAttribute('aria-busy', 'true');
    } else {
      addPortfolioButton.disabled = false;
      addPortfolioButtonText.classList.remove('d-none');
      addPortfolioButtonSpinner.classList.add('d-none');
      addPortfolioButton.setAttribute('aria-busy', 'false');
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
    const liveRegion = document.getElementById('addPortfolio-live-region');
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
    announceToScreenReader('Portfolio creation failed. ' + errorMessage);
    
    // Show error alert
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-danger mt-3';
    alertDiv.setAttribute('role', 'alert');
    alertDiv.innerHTML = `
      <i class="bi bi-exclamation-triangle-fill me-2" aria-hidden="true"></i>
      ${errorMessage}
    `;
    
    if (addPortfolioForm) {
      addPortfolioForm.appendChild(alertDiv);
      
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
    console.error('Add Portfolio page error:', event.error);
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
      initializeLoadingStates,
      initializeAccessibilityFeatures,
      setLoadingState,
      validateField,
      announceToScreenReader,
      handleSubmissionError
    };
  }
})();
