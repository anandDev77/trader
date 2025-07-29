<%@ page language="java" contentType="text/html; charset=UTF-8" session="false"
import="com.ibm.hybrid.cloud.sample.stocktrader.trader.Utilities"%> <%! static
String headerImage = Utilities.getHeaderImage(); static String footerImage =
Utilities.getFooterImage(); %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Stock Trader - Error</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <!-- SEO Meta Tags -->
    <meta name="description" content="StockTrader application error page - something went wrong." />
    <meta name="keywords" content="stock trader error, application error, technical issue" />
    <meta name="author" content="IBM StockTrader" />
    <meta name="robots" content="noindex, nofollow" />
    
    <!-- Open Graph Meta Tags for Social Sharing -->
    <meta property="og:title" content="Stock Trader - Error" />
    <meta property="og:description" content="StockTrader application error" />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="${pageContext.request.requestURL}" />
    <meta property="og:image" content="<%=headerImage%>" />
    
    <!-- Twitter Card Meta Tags -->
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="Stock Trader - Error" />
    <meta name="twitter:description" content="StockTrader application error" />
    
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
      href="${pageContext.request.contextPath}/css/error.css"
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
              <i class="bi bi-exclamation-triangle-fill text-danger me-2" aria-hidden="true"></i>
              <span class="brand-main">Stock</span><span class="brand-accent">Trader</span> Error
            </h1>
          </div>
          <div class="alert alert-danger" role="alert" aria-live="assertive">
            <i class="bi bi-exclamation-triangle-fill me-2" aria-hidden="true"></i>
            <strong>Error:</strong> An error occurred during login. Please try again.
          </div>
          <div class="d-grid">
            <button type="button" class="btn btn-primary" onclick="window.history.back()">
              <i class="bi bi-arrow-repeat me-2" aria-hidden="true"></i>Try Again
            </button>
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
    <script src="${pageContext.request.contextPath}/js/error.js"></script>
  </body>
</html>
