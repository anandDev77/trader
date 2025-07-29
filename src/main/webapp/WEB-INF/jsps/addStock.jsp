<%@ page language="java" contentType="text/html; charset=UTF-8" session="false"
import="com.ibm.hybrid.cloud.sample.stocktrader.trader.Utilities"%> <%! static
String headerImage = Utilities.getHeaderImage(); static String footerImage =
Utilities.getFooterImage(); %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Stock Trader - Add Stock</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <!-- SEO Meta Tags -->
    <meta name="description" content="Buy or sell stocks in your StockTrader portfolio with real-time market data and commission tracking." />
    <meta name="keywords" content="buy stock, sell stock, stock trading, portfolio management, stock trader, investment" />
    <meta name="author" content="IBM StockTrader" />
    <meta name="robots" content="noindex, nofollow" />
    
    <!-- Open Graph Meta Tags for Social Sharing -->
    <meta property="og:title" content="Stock Trader - Add Stock" />
    <meta property="og:description" content="Buy or sell stocks in your portfolio" />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="${pageContext.request.requestURL}" />
    <meta property="og:image" content="<%=headerImage%>" />
    
    <!-- Twitter Card Meta Tags -->
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="Stock Trader - Add Stock" />
    <meta name="twitter:description" content="Buy or sell stocks in your portfolio" />
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico" />
    <link rel="apple-touch-icon" href="${pageContext.request.contextPath}/apple-touch-icon.png" />
    
    <!-- Preload critical resources -->
    <link rel="preload" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" as="style" onload="this.onload=null;this.rel='stylesheet'" />
    <link rel="preload" href="https://fonts.googleapis.com/css?family=Roboto:400,500&display=swap" as="style" crossorigin="anonymous" onload="this.onload=null;this.rel='stylesheet'" />
    <link rel="preload" href="https://fonts.googleapis.com/css?family=Montserrat:700&display=swap" as="style" crossorigin="anonymous" onload="this.onload=null;this.rel='stylesheet'" />
    
    <!-- Fallback for browsers that don't support preload -->
    <noscript>
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
      <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:400,500&display=swap" crossorigin="anonymous" />
      <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Montserrat:700&display=swap" crossorigin="anonymous" />
    </noscript>
    
    <!-- Bootstrap 5 CSS with SRI -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM"
      crossorigin="anonymous"
    />
    
    <!-- Web fonts with SRI -->
    <link
      href="https://fonts.googleapis.com/css?family=Roboto:400,500&display=swap"
      rel="stylesheet"
      crossorigin="anonymous"
    />
    
    <!-- Montserrat font for brand -->
    <link
      href="https://fonts.googleapis.com/css?family=Montserrat:700&display=swap"
      rel="stylesheet"
      crossorigin="anonymous"
    />
    
    <!-- Bootstrap Icons with SRI -->
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
      integrity="sha384-Ay26V7L8bsJTsX9Sxclnvsn+hkdiwRnrjZJXqKmkIDobPgIIWBOVguEcQQLDuhfN"
      crossorigin="anonymous"
    />
    
    <!-- Custom CSS -->
    <link
      rel="stylesheet"
      type="text/css"
      href="${pageContext.request.contextPath}/css/common.css"
    />
    <link
      rel="stylesheet"
      type="text/css"
      href="${pageContext.request.contextPath}/css/addStock.css"
    />
    
    <!-- Content Security Policy -->
    <meta http-equiv="Content-Security-Policy" content="default-src 'self'; script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com https://cdn.jsdelivr.net; img-src 'self' data: https:; connect-src 'self';">
  </head>
  <body class="bg-light">
    <!-- Skip to main content link for accessibility -->
    <a href="#main-content" class="sr-only sr-only-focusable">Skip to main content</a>
    
    <%@ include file="/WEB-INF/jsps/partials/navbar.jspf" %>
    <div
      class="container min-vh-100 d-flex flex-column justify-content-center align-items-center"
      id="main-content"
    >
      <div class="card shadow-sm main-card w-100">
        <div class="card-body p-4">
          <div class="text-center mb-4">
            <img
              src="<%=headerImage%>"
              alt="StockTrader header image with golden bull on blue background"
              class="header-img mb-3"
              loading="eager"
            />
            <h1 class="page-heading text-center mb-4">
              Add <span class="brand-main">Stock</span
              ><span class="brand-accent">Trader</span> Stock
            </h1>
          </div>
          <div class="form-inner">
            <form method="post" class="needs-validation" novalidate id="addStockForm">
              <input type="hidden" name="source" value="${param.source != null ? param.source : 'summary'}" />
              <div class="mb-3">
                <label class="form-label">Transaction Type</label>
                <div class="d-flex gap-3">
                  <div class="form-check">
                    <input
                      class="form-check-input"
                      type="radio"
                      name="action"
                      id="buyAction"
                      value="Buy"
                      checked
                      required
                      aria-describedby="transaction-help"
                    />
                    <label class="form-check-label" for="buyAction">
                      <i class="bi bi-arrow-up-circle text-success me-1" aria-hidden="true"></i>Buy Stock
                    </label>
                  </div>
                  <div class="form-check">
                    <input
                      class="form-check-input"
                      type="radio"
                      name="action"
                      id="sellAction"
                      value="Sell"
                      required
                      aria-describedby="transaction-help"
                    />
                    <label class="form-check-label" for="sellAction">
                      <i class="bi bi-arrow-down-circle text-danger me-1" aria-hidden="true"></i>Sell Stock
                    </label>
                  </div>
                </div>
                <div id="transaction-help" class="form-text">Select whether you want to buy or sell stock</div>
              </div>
              <div class="mb-3">
                <label for="symbol" class="form-label">Stock Symbol</label>
                <div class="input-group">
                  <span class="input-group-text" id="symbol-icon">
                    <i class="bi bi-upc-scan" aria-hidden="true"></i>
                  </span>
                  <input
                    type="text"
                    class="form-control"
                    id="symbol"
                    name="symbol"
                    required
                    aria-describedby="symbol-icon symbol-error"
                    placeholder="Enter stock symbol (e.g., AAPL, GOOGL)"
                    minlength="1"
                    maxlength="10"
                    pattern="[A-Za-z0-9]{1,10}"
                    autocomplete="off"
                  />
                </div>
                <div class="invalid-feedback" id="symbol-error">Please enter a valid stock symbol.</div>
              </div>
              <div class="mb-3">
                <label for="shares" class="form-label">Number of Shares</label>
                <div class="input-group">
                  <span class="input-group-text" id="shares-icon">
                    <i class="bi bi-hash" aria-hidden="true"></i>
                  </span>
                  <input
                    type="number"
                    class="form-control"
                    id="shares"
                    name="shares"
                    step="1"
                    min="1"
                    required
                    aria-describedby="shares-icon shares-error"
                    placeholder="Enter number of shares"
                    autocomplete="off"
                  />
                </div>
                <div class="invalid-feedback" id="shares-error">Please enter a valid number of shares (minimum 1).</div>
              </div>
              <div class="mb-3">
                <label for="owner" class="form-label">Portfolio Owner</label>
                <div class="input-group">
                  <span class="input-group-text" id="owner-icon">
                    <i class="bi bi-person" aria-hidden="true"></i>
                  </span>
                  <input
                    type="text"
                    class="form-control"
                    id="owner"
                    value="${param.owner}"
                    aria-describedby="owner-icon owner-error"
                    placeholder="Enter portfolio owner name"
                    disabled
                  />
                  <input type="hidden" name="owner" value="${param.owner}" />
                </div>
                <div class="invalid-feedback" id="owner-error">Please enter the portfolio owner name.</div>
              </div>
              <div class="mb-3">
                <label class="form-label">Commission</label>
                <div class="d-flex align-items-center">
                  <span class="badge bg-info info-badge me-2">
                    <i class="bi bi-info-circle me-1" aria-hidden="true"></i>Commission: ${commission}
                  </span>
                  <small class="text-muted">Standard commission fee for all transactions</small>
                </div>
              </div>
              <div class="d-grid gap-2">
                <button
                  type="submit"
                  name="submit"
                  value="Submit"
                  class="btn btn-primary"
                  id="addStockButton"
                  aria-describedby="submit-status"
                >
                  <span id="addStockButtonText">
                    <i class="bi bi-arrow-up-circle me-2" aria-hidden="true"></i>Buy Stock
                  </span>
                  <span id="addStockButtonSpinner" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                </button>
                <button
                  type="button"
                  class="btn btn-secondary"
                  onclick="window.history.back()"
                  aria-label="Cancel and go back to previous page"
                >
                  <i class="bi bi-arrow-left me-2" aria-hidden="true"></i>Cancel
                </button>
              </div>
              <!-- Status message for screen readers -->
              <div id="submit-status" class="sr-only" aria-live="polite"></div>
            </form>
          </div>
        </div>
        <div class="card-footer text-center bg-white border-0">
          <a href="https://github.com/IBMStockTrader" aria-label="Visit StockTrader GitHub repository">
            <img
              src="<%=footerImage%>"
              alt="StockTrader footer logo with cloud and building connected by lines"
              class="footer-img"
              loading="lazy"
            />
          </a>
        </div>
      </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script 
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
      crossorigin="anonymous"
    ></script>
    
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/js/addStock.js"></script>
  </body>
</html>
