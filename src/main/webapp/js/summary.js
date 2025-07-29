/**
 * Summary page JavaScript functionality
 * Handles portfolio management, table interactions, and accessibility features
 */

(function() {
  'use strict';

  // DOM elements
  const createPortfolioBtn = document.querySelector('button[name="submit"][value="Submit"]');
  const tableRows = document.querySelectorAll('tbody tr');
  const actionButtons = document.querySelectorAll('.btn-group .btn');

  // Initialize when DOM is ready
  document.addEventListener('DOMContentLoaded', function() {
    initializeTableInteractions();
    initializeAccessibilityFeatures();
  });



  /**
   * Initialize table interactions and accessibility
   */
  function initializeTableInteractions() {
    if (!tableRows.length) return;

    // Add keyboard navigation for table rows
    tableRows.forEach((row, index) => {
      row.setAttribute('tabindex', '0');
      row.setAttribute('role', 'row');
      
      // Keyboard navigation
      row.addEventListener('keydown', function(event) {
        if (event.key === 'Enter' || event.key === ' ') {
          event.preventDefault();
          // Focus on the first action button in the row
          const firstButton = row.querySelector('.btn-group .btn, .dropdown-toggle');
          if (firstButton) {
            firstButton.focus();
          }
        }
      });
    });

    // Enhance action buttons accessibility (desktop)
    actionButtons.forEach(button => {
      button.addEventListener('click', function() {
        // Announce action to screen readers
        const action = this.getAttribute('aria-label') || 'Action performed';
        announceToScreenReader(action);
      });
    });

    // Handle mobile dropdown interactions
    const dropdownToggles = document.querySelectorAll('.dropdown-toggle');
    dropdownToggles.forEach(toggle => {
      toggle.addEventListener('click', function() {
        const owner = this.getAttribute('aria-label')?.match(/for (.+?)'s portfolio/)?.[1] || 'portfolio';
        announceToScreenReader(`Actions menu opened for ${owner}'s portfolio`);
      });
    });

    // Handle dropdown item clicks
    const dropdownItems = document.querySelectorAll('.dropdown-item');
    dropdownItems.forEach(item => {
      item.addEventListener('click', function() {
        const action = this.textContent.trim();
        announceToScreenReader(`${action} action selected`);
      });
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
    liveRegion.id = 'summary-live-region';
    document.body.appendChild(liveRegion);

    // Announce page load to screen readers
    announceToScreenReader('Portfolio summary page loaded. Use tab to navigate through portfolios.');
  }

  /**
   * Remove focus from buttons on page show to prevent "selected" appearance
   */
  window.addEventListener('pageshow', function() {
    const buttons = document.querySelectorAll('.btn');
    buttons.forEach(button => {
      button.blur();
    });
  });

  /**
   * Announce message to screen readers
   * @param {string} message - Message to announce
   */
  function announceToScreenReader(message) {
    const liveRegion = document.getElementById('summary-live-region');
    if (liveRegion) {
      liveRegion.textContent = message;
      // Clear message after a short delay
      setTimeout(() => {
        liveRegion.textContent = '';
      }, 3000);
    }
  }

  /**
   * Handle table row selection and focus management
   * @param {HTMLElement} row - The table row element
   */
  function handleRowSelection(row) {
    // Remove focus from other rows
    tableRows.forEach(r => r.classList.remove('table-active'));
    // Add focus to current row
    row.classList.add('table-active');
  }

  /**
   * Handle form submission errors
   * @param {string} errorMessage - Error message to display
   */
  function handleSubmissionError(errorMessage) {
    announceToScreenReader('Error: ' + errorMessage);
    
    // Show error alert
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-danger mt-3';
    alertDiv.setAttribute('role', 'alert');
    alertDiv.innerHTML = `
      <i class="bi bi-exclamation-triangle-fill me-2" aria-hidden="true"></i>
      ${errorMessage}
    `;
    
    if (summaryForm) {
      summaryForm.appendChild(alertDiv);
      
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
    console.error('Summary page error:', event.error);
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
      initializeTableInteractions,
      initializeAccessibilityFeatures,
      announceToScreenReader,
      handleRowSelection,
      handleSubmissionError
    };
  }
})();
