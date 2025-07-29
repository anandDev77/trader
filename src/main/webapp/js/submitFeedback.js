/**
 * Submit Feedback page JavaScript functionality
 * Handles form validation, loading states, and accessibility features
 */

(function() {
  'use strict';

  // DOM elements
  const feedbackForm = document.getElementById('feedbackForm');
  const submitFeedbackButton = document.getElementById('submitFeedbackButton');
  const submitFeedbackButtonText = document.getElementById('submitFeedbackButtonText');
  const submitFeedbackButtonSpinner = document.getElementById('submitFeedbackButtonSpinner');
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
    if (!feedbackForm) return;

    // Prevent form submission if validation fails
    feedbackForm.addEventListener('submit', function(event) {
      if (!feedbackForm.checkValidity()) {
          event.preventDefault();
          event.stopPropagation();
        
        // Announce validation error to screen readers
        announceToScreenReader('Please fix the form errors before submitting.');
      } else {
        // Show loading state
        setLoadingState(true);
        announceToScreenReader('Submitting feedback...');
      }
      
      feedbackForm.classList.add('was-validated');
    }, false);

    // Real-time validation feedback
    const inputs = feedbackForm.querySelectorAll('textarea[required]');
    inputs.forEach(input => {
      input.addEventListener('blur', function() {
        validateField(input);
      });
      
      input.addEventListener('input', function() {
        // Clear validation state on input
        if (input.classList.contains('is-valid') || input.classList.contains('is-invalid')) {
          input.classList.remove('is-valid', 'is-invalid');
        }
        
        // Update character count for accessibility
        updateCharacterCount(input);
      });
    });
  }

  /**
   * Initialize loading states
   */
  function initializeLoadingStates() {
    if (!feedbackForm) return;

    // Reset loading state on page load
    setLoadingState(false);
    
    // Handle form submission timeout
    feedbackForm.addEventListener('submit', function() {
      // Set a timeout to show loading state for at least 500ms
      setTimeout(() => {
        if (submitFeedbackButton && submitFeedbackButton.disabled) {
          announceToScreenReader('Feedback submission is taking longer than expected. Please wait.');
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
    liveRegion.id = 'feedback-live-region';
    document.body.appendChild(liveRegion);

    // Announce page load to screen readers
    announceToScreenReader('Submit feedback page loaded. Enter your feedback in the text area.');
  }

  /**
   * Set loading state for the submit button
   * @param {boolean} isLoading - Whether to show loading state
   */
  function setLoadingState(isLoading) {
    if (!submitFeedbackButton || !submitFeedbackButtonText || !submitFeedbackButtonSpinner) return;

    if (isLoading) {
      submitFeedbackButton.disabled = true;
      submitFeedbackButtonText.classList.add('d-none');
      submitFeedbackButtonSpinner.classList.remove('d-none');
      submitFeedbackButton.setAttribute('aria-busy', 'true');
    } else {
      submitFeedbackButton.disabled = false;
      submitFeedbackButtonText.classList.remove('d-none');
      submitFeedbackButtonSpinner.classList.add('d-none');
      submitFeedbackButton.setAttribute('aria-busy', 'false');
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
   * Update character count for accessibility
   * @param {HTMLElement} textarea - The textarea element
   */
  function updateCharacterCount(textarea) {
    const currentLength = textarea.value.length;
    const minLength = textarea.getAttribute('minlength') || 5;
    const maxLength = textarea.getAttribute('maxlength') || 1000;
    
    // Announce character count to screen readers
    if (currentLength >= minLength) {
      announceToScreenReader(`Feedback length: ${currentLength} characters`);
    }
  }

  /**
   * Announce message to screen readers
   * @param {string} message - Message to announce
   */
  function announceToScreenReader(message) {
    const liveRegion = document.getElementById('feedback-live-region');
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
    announceToScreenReader('Feedback submission failed. ' + errorMessage);
    
    // Show error alert
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-danger mt-3';
    alertDiv.setAttribute('role', 'alert');
    alertDiv.innerHTML = `
      <i class="bi bi-exclamation-triangle-fill me-2" aria-hidden="true"></i>
      ${errorMessage}
    `;
    
    if (feedbackForm) {
      feedbackForm.appendChild(alertDiv);
      
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
    console.error('Submit Feedback page error:', event.error);
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
      updateCharacterCount,
      announceToScreenReader,
      handleSubmissionError
    };
  }
})();
