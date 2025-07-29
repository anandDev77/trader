/**
 * Login page JavaScript functionality
 * Handles form validation, password toggle, and loading states
 */

(function() {
  'use strict';

  // DOM elements
  const loginForm = document.getElementById('loginForm');
  const loginButton = document.getElementById('loginButton');
  const loginButtonText = document.getElementById('loginButtonText');
  const loginButtonSpinner = document.getElementById('loginButtonSpinner');
  const loginStatus = document.getElementById('login-status');
  const passwordInput = document.getElementById('password');
  const togglePasswordBtn = document.getElementById('togglePassword');
  const togglePasswordIcon = document.getElementById('togglePasswordIcon');

  // Initialize when DOM is ready
  document.addEventListener('DOMContentLoaded', function() {
    initializeFormValidation();
    initializePasswordToggle();
    initializeLoadingStates();
    initializeAccessibilityFeatures();
  });

  // Also reset loading state when page becomes visible (for back button scenarios)
  document.addEventListener('pageshow', function() {
    setLoadingState(false);
  });

  // Reset loading state when page is loaded from cache
  window.addEventListener('load', function() {
    setLoadingState(false);
  });

  /**
   * Initialize Bootstrap form validation
   */
  function initializeFormValidation() {
    if (!loginForm) return;

    // Prevent form submission if validation fails
    loginForm.addEventListener('submit', function(event) {
      if (!loginForm.checkValidity()) {
        event.preventDefault();
        event.stopPropagation();
        
        // Announce validation error to screen readers
        announceToScreenReader('Please fix the form errors before submitting.');
      } else {
        // Show loading state
        setLoadingState(true);
        announceToScreenReader('Submitting login form...');
      }
      
      loginForm.classList.add('was-validated');
    }, false);

    // Real-time validation feedback
    const inputs = loginForm.querySelectorAll('input[required]');
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
   * Initialize password visibility toggle
   */
  function initializePasswordToggle() {
    if (!passwordInput || !togglePasswordBtn || !togglePasswordIcon) return;

    togglePasswordBtn.addEventListener('click', function() {
      const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
      passwordInput.setAttribute('type', type);
      
      // Toggle icon
      if (type === 'text') {
        togglePasswordIcon.classList.remove('bi-eye');
        togglePasswordIcon.classList.add('bi-eye-slash');
        togglePasswordBtn.setAttribute('aria-pressed', 'true');
        announceToScreenReader('Password is now visible');
      } else {
        togglePasswordIcon.classList.remove('bi-eye-slash');
        togglePasswordIcon.classList.add('bi-eye');
        togglePasswordBtn.setAttribute('aria-pressed', 'false');
        announceToScreenReader('Password is now hidden');
      }
    });

    // Keyboard support for password toggle
    togglePasswordBtn.addEventListener('keydown', function(event) {
      if (event.key === 'Enter' || event.key === ' ') {
        event.preventDefault();
        togglePasswordBtn.click();
      }
    });
  }

  /**
   * Initialize loading states
   */
  function initializeLoadingStates() {
    if (!loginForm) return;

    // Reset loading state on page load
    setLoadingState(false);
    
    // Handle form submission timeout
    loginForm.addEventListener('submit', function() {
      // Set a timeout to show loading state for at least 500ms
      setTimeout(() => {
        if (loginButton && loginButton.disabled) {
          announceToScreenReader('Login request is taking longer than expected. Please wait.');
        }
      }, 500);
    });

    // Reset loading state when form is reset or page is refreshed
    loginForm.addEventListener('reset', function() {
      setLoadingState(false);
    });

    // Handle browser back/forward navigation
    window.addEventListener('beforeunload', function() {
      setLoadingState(false);
    });

    // Force reset loading state after a short delay to catch any lingering states
    setTimeout(() => {
      setLoadingState(false);
    }, 100);
  }

  /**
   * Set loading state for the login button
   * @param {boolean} isLoading - Whether to show loading state
   */
  function setLoadingState(isLoading) {
    if (!loginButton || !loginButtonText || !loginButtonSpinner) return;

    if (isLoading) {
      loginButton.disabled = true;
      loginButtonText.classList.add('d-none');
      loginButtonSpinner.classList.remove('d-none');
      loginButton.setAttribute('aria-busy', 'true');
    } else {
      loginButton.disabled = false;
      loginButtonText.classList.remove('d-none');
      loginButtonSpinner.classList.add('d-none');
      loginButton.setAttribute('aria-busy', 'false');
      
      // Ensure the button is fully reset
      loginButton.removeAttribute('aria-busy');
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
   * Initialize accessibility features
   */
  function initializeAccessibilityFeatures() {
    // Create live region for screen reader announcements
    const liveRegion = document.createElement('div');
    liveRegion.setAttribute('aria-live', 'polite');
    liveRegion.setAttribute('aria-atomic', 'true');
    liveRegion.className = 'sr-only';
    document.body.appendChild(liveRegion);

    // Announce page load to screen readers
    announceToScreenReader('Login page loaded');
  }

  /**
   * Announce message to screen readers
   */
  function announceToScreenReader(message) {
    const liveRegion = document.querySelector('[aria-live="polite"]');
    if (liveRegion) {
      liveRegion.textContent = message;
    }
  }

  /**
   * Handle submission errors
   */
  function handleSubmissionError(errorMessage) {
    // Create temporary error alert
    const errorAlert = document.createElement('div');
    errorAlert.className = 'alert alert-danger alert-dismissible fade show';
    errorAlert.setAttribute('role', 'alert');
    errorAlert.innerHTML = `
      <i class="bi bi-exclamation-triangle me-2" aria-hidden="true"></i>
      ${errorMessage}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `;
    
    // Insert before the form
    const form = document.getElementById('loginForm');
    if (form) {
      form.parentNode.insertBefore(errorAlert, form);
      
      // Auto-remove after 5 seconds
      setTimeout(() => {
        if (errorAlert.parentNode) {
          errorAlert.remove();
        }
      }, 5000);
    }
  }

  // Global error handler for this page
  window.addEventListener('error', function(event) {
    console.error('Login page error:', event.error);
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
      initializePasswordToggle,
      setLoadingState,
      validateField,
      announceToScreenReader,
      handleSubmissionError
    };
  }
})();
