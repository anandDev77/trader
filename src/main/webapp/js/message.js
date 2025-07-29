/**
 * Message page JavaScript functionality
 * Handles accessibility features and error handling
 */
(function() {
  'use strict';

  document.addEventListener('DOMContentLoaded', function() {
    initializeAccessibilityFeatures();
  });

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
    announceToScreenReader('Message page loaded');
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
    
    // Insert before the main content
    const mainContent = document.getElementById('main-content');
    if (mainContent) {
      mainContent.parentNode.insertBefore(errorAlert, mainContent);
      
      // Auto-remove after 5 seconds
      setTimeout(() => {
        if (errorAlert.parentNode) {
          errorAlert.remove();
        }
      }, 5000);
    }
  }

  // Global error handler
  window.addEventListener('error', function(event) {
    console.error('Message page error:', event.error);
    handleSubmissionError('An unexpected error occurred. Please try again.');
  });

  // Offline handler
  window.addEventListener('offline', function() {
    handleSubmissionError('You are offline. Please check your internet connection.');
  });

  // Export functions for testing (if needed)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
      initializeAccessibilityFeatures,
      announceToScreenReader,
      handleSubmissionError
    };
  }
})(); 