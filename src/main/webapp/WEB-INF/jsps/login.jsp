<%@ page language="java" contentType="text/html; charset=UTF-8" session="false"
import="com.ibm.hybrid.cloud.sample.stocktrader.trader.Utilities"%> <%! static
String headerImage = Utilities.getHeaderImage(); static String footerImage =
Utilities.getFooterImage(); static String loginMessage =
Utilities.getLoginMessage(); %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Stock Trader - Login</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <!-- SEO Meta Tags -->
    <meta name="description" content="Login to StockTrader - Manage your investment portfolios with real-time stock tracking and portfolio analytics." />
    <meta name="keywords" content="stock trader, portfolio management, investment, trading, stocks" />
    <meta name="author" content="IBM StockTrader" />
    <meta name="robots" content="noindex, nofollow" />
    
    <!-- Open Graph Meta Tags for Social Sharing -->
    <meta property="og:title" content="Stock Trader - Login" />
    <meta property="og:description" content="Login to StockTrader - Manage your investment portfolios" />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="${pageContext.request.requestURL}" />
    <meta property="og:image" content="<%=headerImage%>" />
    
    <!-- Twitter Card Meta Tags -->
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="Stock Trader - Login" />
    <meta name="twitter:description" content="Login to StockTrader - Manage your investment portfolios" />
    
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

    <!-- Bootstrap Icons CDN with SRI -->
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
      href="${pageContext.request.contextPath}/css/login.css"
    />
    
    <!-- Content Security Policy -->
    <meta http-equiv="Content-Security-Policy" content="default-src 'self'; script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com https://cdn.jsdelivr.net; img-src 'self' data: https:; connect-src 'self';">
  </head>
  <body class="bg-light">
    <!-- Skip to main content link for accessibility -->
    <a href="#main-content" class="sr-only sr-only-focusable">Skip to main content</a>
    
    <!-- Main container centers the card vertically and horizontally -->
    <div
      class="container min-vh-100 d-flex flex-column justify-content-center align-items-center"
      id="main-content"
    >
      <div class="card shadow-sm main-card w-100">
        <div class="card-body p-4">
          <div class="text-center mb-4">
            <!-- Header image loaded dynamically -->
            <img
              src="<%=headerImage%>"
              alt="StockTrader header image with golden bull on blue background"
              class="header-img mb-3"
              loading="eager"
            />
            <!-- Login message from backend utility -->
            <h1 class="login-heading text-center mb-4">
              Login to <span class="brand-main">Stock</span
              ><span class="brand-accent">Trader</span>
            </h1>
          </div>
          <div class="form-inner">
            <!-- Login Form: Bootstrap, accessible, responsive -->
            <form method="post" class="needs-validation" novalidate id="loginForm">
              <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <div class="input-group">
                  <span class="input-group-text" id="username-icon">
                    <i class="bi bi-person" aria-hidden="true"></i>
                  </span>
                  <input
                    type="text"
                    class="form-control"
                    id="username"
                    name="id"
                    required
                    aria-required="true"
                    aria-describedby="username-icon username-error"
                    autocomplete="username"
                    placeholder="Enter your username"
                    minlength="1"
                    maxlength="50"
                  />
                </div>
                <div class="invalid-feedback" id="username-error">Please enter your username.</div>
              </div>
              <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <div class="input-group">
                  <span class="input-group-text" id="password-icon">
                    <i class="bi bi-lock" aria-hidden="true"></i>
                  </span>
                  <input
                    type="password"
                    class="form-control"
                    id="password"
                    name="password"
                    required
                    aria-required="true"
                    aria-describedby="password-icon password-error togglePassword"
                    autocomplete="current-password"
                    placeholder="Enter your password"
                    minlength="1"
                    maxlength="100"
                  />
                  <button
                    class="btn btn-outline-secondary"
                    type="button"
                    id="togglePassword"
                    tabindex="-1"
                    aria-label="Show or hide password"
                    aria-pressed="false"
                  >
                    <span id="togglePasswordIcon" class="bi bi-eye" aria-hidden="true"></span>
                  </button>
                </div>
                <div class="invalid-feedback" id="password-error">Please enter your password.</div>
              </div>
              <div class="d-grid">
                <button
                  type="submit"
                  name="submit"
                  class="btn btn-primary btn-block"
                  id="loginButton"
                  aria-describedby="login-status"
                >
                  <span id="loginButtonText">
                    <i class="bi bi-box-arrow-in-right me-2" aria-hidden="true"></i>Login
                  </span>
                  <span id="loginButtonSpinner" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                </button>
              </div>
              <!-- Status message for screen readers -->
              <div id="login-status" class="sr-only" aria-live="polite"></div>
            </form>
          </div>
        </div>
        <div class="card-footer text-center bg-white border-0">
          <!-- Footer image loaded dynamically -->
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
    
    <!-- Bootstrap JS with SRI -->
    <script 
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz"
      crossorigin="anonymous"
    ></script>
    
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/js/login.js"></script>
  </body>
</html>
