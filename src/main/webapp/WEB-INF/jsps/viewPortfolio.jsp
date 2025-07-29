<%@ page language="java" contentType="text/html; charset=UTF-8" session="false" 
import="java.text.*,java.util.List,java.math.RoundingMode,com.ibm.hybrid.cloud.sample.stocktrader.trader.Utilities,com.ibm.hybrid.cloud.sample.stocktrader.trader.json.*"%>

<%!
static String headerImage  = Utilities.getHeaderImage();
static String footerImage  = Utilities.getFooterImage();

static NumberFormat currency = NumberFormat.getNumberInstance();
static {
  currency.setMinimumFractionDigits(2);
  currency.setMaximumFractionDigits(2);
  currency.setRoundingMode(RoundingMode.HALF_UP);
} 
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Stock Trader - View Portfolio</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <!-- SEO Meta Tags -->
    <meta name="description" content="View detailed portfolio information including stocks, balances, and transaction history in StockTrader." />
    <meta name="keywords" content="view portfolio, portfolio details, stock holdings, transaction history, portfolio analytics" />
    <meta name="author" content="IBM StockTrader" />
    <meta name="robots" content="noindex, nofollow" />
    
    <!-- Open Graph Meta Tags for Social Sharing -->
    <meta property="og:title" content="Stock Trader - View Portfolio" />
    <meta property="og:description" content="View detailed portfolio information" />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="${pageContext.request.requestURL}" />
    <meta property="og:image" content="<%=headerImage%>" />
    
    <!-- Twitter Card Meta Tags -->
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="Stock Trader - View Portfolio" />
    <meta name="twitter:description" content="View detailed portfolio information" />
    
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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM"
          crossorigin="anonymous">
    
    <!-- Web fonts with SRI -->
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,500&display=swap" rel="stylesheet"
          crossorigin="anonymous">
    
    <!-- Montserrat font for brand -->
    <link href="https://fonts.googleapis.com/css?family=Montserrat:700&display=swap" rel="stylesheet"
          crossorigin="anonymous">
    
    <!-- Bootstrap Icons with SRI -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
          integrity="sha384-Ay26V7L8bsJTsX9Sxclnvsn+hkdiwRnrjZJXqKmkIDobPgIIWBOVguEcQQLDuhfN"
          crossorigin="anonymous">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/viewPortfolio.css">
    
    <!-- Content Security Policy -->
    <meta http-equiv="Content-Security-Policy" content="default-src 'self'; script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com https://cdn.jsdelivr.net; img-src 'self' data: https:; connect-src 'self';">
  </head>
  <body class="bg-light">
    <!-- Skip to main content link for accessibility -->
    <a href="#main-content" class="sr-only sr-only-focusable">Skip to main content</a>
    
    <%@ include file="/WEB-INF/jsps/partials/navbar.jspf" %>
    <div class="container min-vh-100 d-flex flex-column justify-content-center align-items-center" id="main-content">
      <div class="card shadow-sm main-card w-100">
        <div class="card-body">
          <div class="mb-3 text-center">
            <h1 class="page-heading mb-2">
              <i class="bi bi-person-circle text-primary me-2" aria-hidden="true"></i>
              <span class="brand-main">Stock</span><span class="brand-accent">Trader</span> Portfolio Details
            </h1>
          </div>
          <img src="<%=headerImage%>" alt="StockTrader header image with golden bull on blue background" class="header-img mb-3" loading="eager"/>
          <div class="mb-4"></div>
          
          <% if(request.getAttribute("error") != null && ((Boolean)request.getAttribute("error")).booleanValue() == true) { %>
            <div class="alert alert-danger" role="alert" aria-live="assertive">
              <i class="bi bi-exclamation-triangle-fill me-2" aria-hidden="true"></i>
              Error: ${message}
            </div>
          <% } else { %>
            <% Broker broker = (Broker)request.getAttribute("broker"); %>
            <% if(broker != null) { %>
              <div class="row mb-4">
                <div class="col-md-6 mb-3">
                  <div class="card h-100">
                    <div class="card-header bg-primary text-white">
                      <h5 class="card-title mb-0">
                        <i class="bi bi-person me-2" aria-hidden="true"></i>Portfolio Owner
                      </h5>
                    </div>
                    <div class="card-body">
                      <h4 class="text-primary"><%=broker.getOwner()%></h4>
                      <p class="text-muted mb-0">Portfolio Owner</p>
                    </div>
                  </div>
                </div>
                <div class="col-md-6 mb-3">
                  <div class="card h-100">
                    <div class="card-header bg-success text-white">
                      <h5 class="card-title mb-0">
                        <i class="bi bi-cash-stack me-2" aria-hidden="true"></i>Total Value
                      </h5>
                    </div>
                    <div class="card-body">
                      <h4 class="text-success">$<%=currency.format(broker.getTotal())%></h4>
                      <p class="text-muted mb-0">Portfolio Total</p>
                    </div>
                  </div>
                </div>
              </div>
              
              <div class="row mb-4">
                <div class="col-md-6 mb-3">
                  <div class="card h-100">
                    <div class="card-header bg-info text-white">
                      <h5 class="card-title mb-0">
                        <i class="bi bi-currency-exchange me-2" aria-hidden="true"></i>Cash Balance
                      </h5>
                    </div>
                    <div class="card-body">
                      <h4 class="text-info">$<%=currency.format(broker.getBalance())%></h4>
                      <p class="text-muted mb-0">Available Cash</p>
                    </div>
                  </div>
                </div>
                <div class="col-md-6 mb-3">
                  <div class="card h-100">
                    <div class="card-header bg-warning text-dark">
                      <h5 class="card-title mb-0">
                        <i class="bi bi-award me-2" aria-hidden="true"></i>Loyalty Level
                      </h5>
                    </div>
                    <div class="card-body">
                      <h4 class="text-warning"><%=broker.getLoyalty()%></h4>
                      <p class="text-muted mb-0">Customer Tier</p>
                    </div>
                  </div>
                </div>
              </div>
              
              <% List<Stock> stocks = broker.getStocks(); %>
              <% if(stocks != null && !stocks.isEmpty()) { %>
                <div class="card mb-4">
                  <div class="card-header bg-dark text-white">
                    <h5 class="card-title mb-0">
                      <i class="bi bi-graph-up me-2" aria-hidden="true"></i>Stock Holdings
                    </h5>
                  </div>
                  <div class="card-body p-0">
                    <div class="table-responsive">
                      <table class="table table-hover mb-0" role="table" aria-label="Stock holdings table">
                        <thead class="table-light">
                          <tr>
                            <th scope="col"><i class="bi bi-tag" aria-hidden="true"></i> Symbol</th>
                            <th scope="col"><i class="bi bi-hash" aria-hidden="true"></i> Shares</th>
                            <th scope="col"><i class="bi bi-currency-dollar" aria-hidden="true"></i> Price</th>
                            <th scope="col"><i class="bi bi-calculator" aria-hidden="true"></i> Total</th>
		    </tr>
                        </thead>
                        <tbody>
                          <% for(Stock stock : stocks) { %>
                            <tr>
                              <td><strong><%=stock.getSymbol()%></strong></td>
                              <td><%=stock.getShares()%></td>
                              <td>$<%=currency.format(stock.getPrice())%></td>
                              <td>$<%=currency.format(stock.getShares() * stock.getPrice())%></td>
		    </tr>
                          <% } %>
                        </tbody>
		  </table>
                    </div>
                  </div>
                </div>
              <% } else { %>
                <div class="alert alert-info" role="alert" aria-live="polite">
                  <i class="bi bi-info-circle me-2" aria-hidden="true"></i>
                  No stocks in this portfolio yet. Add some stocks to get started!
                </div>
              <% } %>
              
              <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                <form method="post" style="display:inline;">
                  <input type="hidden" name="action" value="addStock"/>
                  <input type="hidden" name="owner" value="<%=broker.getOwner()%>"/>
                  <button type="submit" name="submit" value="Submit" class="btn btn-success me-2">
                    <i class="bi bi-plus-circle me-1" aria-hidden="true"></i>Add Stock
                  </button>
		</form>
                <button type="button" class="btn btn-secondary" onclick="window.history.back()">
                  <i class="bi bi-arrow-left me-1" aria-hidden="true"></i>Back
                </button>
              </div>
            <% } else { %>
              <div class="alert alert-warning" role="alert" aria-live="assertive">
                <i class="bi bi-exclamation-triangle me-2" aria-hidden="true"></i>
                Portfolio not found or access denied.
              </div>
            <% } %>
          <% } %>
        </div>
        <div class="card-footer text-center bg-white border-0">
          <a href="https://github.com/IBMStockTrader" aria-label="Visit StockTrader GitHub repository">
            <img src="<%=footerImage%>" alt="StockTrader footer logo with cloud and building connected by lines" class="footer-img" loading="lazy"/>
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
    <script src="${pageContext.request.contextPath}/js/viewPortfolio.js"></script>
  </body>
</html>
