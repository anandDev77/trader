/**
 * View Portfolio page JavaScript functionality
 * Handles portfolio display, accessibility features, and performance monitoring
 */

(function() {
  'use strict';

  // DOM elements
  const portfolioCards = document.querySelectorAll('.card');
  const stockTable = document.querySelector('table[role="table"]');
  const actionButtons = document.querySelectorAll('.btn');

  // Initialize when DOM is ready
  document.addEventListener('DOMContentLoaded', function() {
    initializeAccessibilityFeatures();
    initializeCardInteractions();
  });

  /**
   * Initialize accessibility features
   */
  function initializeAccessibilityFeatures() {
    // Add live region for dynamic content
    const liveRegion = document.createElement('div');
    liveRegion.setAttribute('aria-live', 'polite');
    liveRegion.setAttribute('aria-atomic', 'true');
    liveRegion.className = 'sr-only';
    liveRegion.id = 'viewPortfolio-live-region';
    document.body.appendChild(liveRegion);

    // Announce page load to screen readers
    announceToScreenReader('Portfolio details page loaded. Viewing portfolio information and stock holdings.');
  }

  /**
   * Initialize card interactions
   */
  function initializeCardInteractions() {
    if (!portfolioCards.length) return;

    // Add keyboard navigation for cards
    portfolioCards.forEach((card, index) => {
      card.setAttribute('tabindex', '0');
      card.setAttribute('role', 'button');
      
      // Keyboard navigation
      card.addEventListener('keydown', function(event) {
        if (event.key === 'Enter' || event.key === ' ') {
          event.preventDefault();
          // Focus on the first action button in the card
          const firstButton = card.querySelector('.btn');
          if (firstButton) {
            firstButton.focus();
          }
        }
      });
    });
  }

  /**
   * Announce message to screen readers
   * @param {string} message - Message to announce
   */
  function announceToScreenReader(message) {
    const liveRegion = document.getElementById('viewPortfolio-live-region');
    if (liveRegion) {
      liveRegion.textContent = message;
      // Clear message after a short delay
      setTimeout(() => {
        liveRegion.textContent = '';
      }, 3000);
    }
  }

  /**
   * Handle portfolio data loading errors
   * @param {string} errorMessage - Error message to display
   */
  function handlePortfolioError(errorMessage) {
    announceToScreenReader('Portfolio loading error. ' + errorMessage);
    
    // Show error alert
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-danger mt-3';
    alertDiv.setAttribute('role', 'alert');
    alertDiv.innerHTML = `
      <i class="bi bi-exclamation-triangle-fill me-2" aria-hidden="true"></i>
      ${errorMessage}
    `;
    
    const container = document.querySelector('.container');
    if (container) {
      container.appendChild(alertDiv);
      
      // Remove alert after 5 seconds
      setTimeout(() => {
        if (alertDiv.parentNode) {
          alertDiv.remove();
        }
      }, 5000);
    }
  }

  /**
   * Handle action button clicks
   * @param {HTMLElement} button - The clicked button
   */
  function handleActionClick(button) {
    const action = button.getAttribute('aria-label') || 'Action';
    announceToScreenReader(`${action} initiated`);
  }

  // Add event listeners for action buttons
  actionButtons.forEach(button => {
    button.addEventListener('click', function() {
      handleActionClick(this);
    });
  });

  // Global error handler for this page
  window.addEventListener('error', function(event) {
    console.error('View Portfolio page error:', event.error);
    handlePortfolioError('An unexpected error occurred while loading portfolio data.');
  });

  // Handle network errors
  window.addEventListener('offline', function() {
    handlePortfolioError('No internet connection. Please check your network and try again.');
  });

  // Export functions for testing (if needed)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
      initializeAccessibilityFeatures,
      initializeCardInteractions,
      announceToScreenReader,
      handlePortfolioError,
      handleActionClick
    };
  }
})();
