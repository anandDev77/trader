<%@ page language="java" contentType="text/html; charset=UTF-8" session="false"
import="com.ibm.hybrid.cloud.sample.stocktrader.trader.Utilities"%> <%! static
String headerImage = Utilities.getHeaderImage(); static String footerImage =
Utilities.getFooterImage(); %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Stock Trader - Add Portfolio</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <!-- SEO Meta Tags -->
    <meta name="description" content="Create a new StockTrader investment portfolio with initial balance and currency selection." />
    <meta name="keywords" content="add portfolio, create portfolio, stock trader, investment account, portfolio management" />
    <meta name="author" content="IBM StockTrader" />
    <meta name="robots" content="noindex, nofollow" />
    
    <!-- Open Graph Meta Tags for Social Sharing -->
    <meta property="og:title" content="Stock Trader - Add Portfolio" />
    <meta property="og:description" content="Create a new investment portfolio" />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="${pageContext.request.requestURL}" />
    <meta property="og:image" content="<%=headerImage%>" />
    
    <!-- Twitter Card Meta Tags -->
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="Stock Trader - Add Portfolio" />
    <meta name="twitter:description" content="Create a new investment portfolio" />
    
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
      href="${pageContext.request.contextPath}/css/addPortfolio.css"
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
              ><span class="brand-accent">Trader</span> Portfolio
            </h1>
            <div class="alert alert-info" role="alert" aria-live="polite">
              <i class="bi bi-info-circle me-2" aria-hidden="true"></i>
              This account will receive a free <b>$50</b> balance for commissions!
            </div>
          </div>
          <div class="form-inner">
            <form method="post" class="needs-validation" novalidate id="addPortfolioForm">
              <div class="mb-3">
                <label for="owner" class="form-label">Owner</label>
                <div class="input-group">
                  <span class="input-group-text" id="owner-icon">
                    <i class="bi bi-person" aria-hidden="true"></i>
                  </span>
                  <input
                    type="text"
                    class="form-control"
                    id="owner"
                    name="owner"
                    required
                    aria-describedby="owner-icon owner-error"
                    placeholder="Enter portfolio owner name"
                    minlength="1"
                    maxlength="50"
                    autocomplete="name"
                  />
                </div>
                <div class="invalid-feedback" id="owner-error">Please enter the owner name.</div>
              </div>
              <div class="mb-3">
                <label for="balance" class="form-label">Cash Account initial balance</label>
                <div class="input-group">
                  <span class="input-group-text" id="balance-icon">
                    <i class="bi bi-cash-stack" aria-hidden="true"></i>
                  </span>
                  <input
                    type="number"
                    class="form-control"
                    id="balance"
                    name="balance"
                    step="0.01"
                    min="0"
                    value="10000.00"
                    required
                    aria-describedby="balance-icon balance-error"
                    placeholder="Enter initial balance"
                    autocomplete="off"
                  />
                </div>
                <div class="invalid-feedback" id="balance-error">Please enter a valid initial balance.</div>
              </div>
              <div class="mb-3">
                <label for="currency" class="form-label">Cash Account currency</label>
                <div class="input-group">
                  <span class="input-group-text" id="currency-icon">
                    <i class="bi bi-currency-exchange" aria-hidden="true"></i>
                  </span>
                  <select
                    class="form-select"
                    id="currency"
                    name="currency"
                    required
                    aria-describedby="currency-icon currency-error"
                  >
                    <option value="USD" selected>United States Dollar</option>
                    <option value="AUD">Australian Dollar</option>
                    <option value="BGN">Bulgarian Lev</option>
                    <option value="BRL">Brazilian Real</option>
                    <option value="CAD">Canadian Dollar</option>
                    <option value="CHF">Swiss Franc</option>
                    <option value="CNY">Chinese Renminbi Yuan</option>
                    <option value="DKK">Danish Krone</option>
                    <option value="EUR">Euro</option>
                    <option value="GBP">British Pound</option>
                    <option value="HKD">Hong Kong Dollar</option>
                    <option value="HUF">Hungarian Forint</option>
                    <option value="IDR">Indonesian Rupiah</option>
                    <option value="ILS">Israeli New Sheqel</option>
                    <option value="INR">Indian Rupee</option>
                    <option value="ISK">Icelandic Króna</option>
                    <option value="JPY">Japanese Yen</option>
                    <option value="KRW">South Korean Won</option>
                    <option value="MXN">Mexican Peso</option>
                    <option value="MYR">Malaysian Ringgit</option>
                    <option value="NOK">Norwegian Krone</option>
                    <option value="NZD">New Zealand Dollar</option>
                    <option value="PHP">Philippine Peso</option>
                    <option value="PLN">Polish Złoty</option>
                    <option value="RON">Romanian Leu</option>
                    <option value="SEK">Swedish Krona</option>
                    <option value="SGD">Singapore Dollar</option>
                    <option value="THB">Thai Baht</option>
                    <option value="TRY">Turkish Lira</option>
                    <option value="ZAR">South African Rand</option>
                  </select>
                </div>
                <div class="invalid-feedback" id="currency-error">Please select a currency.</div>
              </div>
              <div class="d-grid gap-2">
                <button
                  type="submit"
                  name="submit"
                  class="btn btn-primary"
                  id="addPortfolioButton"
                  aria-describedby="submit-status"
                >
                  <span id="addPortfolioButtonText">
                    <i class="bi bi-plus-circle me-2" aria-hidden="true"></i>Add Portfolio
                  </span>
                  <span id="addPortfolioButtonSpinner" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
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
    <script src="${pageContext.request.contextPath}/js/addPortfolio.js"></script>
  </body>
</html>
