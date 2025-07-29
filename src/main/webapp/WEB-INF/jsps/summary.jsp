<%@ page language="java" contentType="text/html; charset=UTF-8" session="false" 
import="java.text.*,java.util.List,java.math.RoundingMode,com.ibm.hybrid.cloud.sample.stocktrader.trader.Utilities,com.ibm.hybrid.cloud.sample.stocktrader.trader.json.*"%>

<%!
static String headerImage  = Utilities.getHeaderImage();
static String footerImage  = Utilities.getFooterImage();
static String loginMessage = Utilities.getLoginMessage();

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
    <title>Stock Trader - Portfolio Summary</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <!-- SEO Meta Tags -->
    <meta name="description" content="View and manage your StockTrader investment portfolios with real-time portfolio analytics and loyalty tracking." />
    <meta name="keywords" content="portfolio summary, stock trader, investment management, portfolio analytics, loyalty levels" />
    <meta name="author" content="IBM StockTrader" />
    <meta name="robots" content="noindex, nofollow" />
    
    <!-- Open Graph Meta Tags for Social Sharing -->
    <meta property="og:title" content="Stock Trader - Portfolio Summary" />
    <meta property="og:description" content="View and manage your investment portfolios" />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="${pageContext.request.requestURL}" />
    <meta property="og:image" content="<%=headerImage%>" />
    
    <!-- Twitter Card Meta Tags -->
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="Stock Trader - Portfolio Summary" />
    <meta name="twitter:description" content="View and manage your investment portfolios" />
    
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
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/summary.css">
    
    <!-- Content Security Policy -->
    <meta http-equiv="Content-Security-Policy" content="default-src 'self'; script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com https://cdn.jsdelivr.net; img-src 'self' data: https:; connect-src 'self';">
  </head>
  <body class="bg-light">
    <!-- Skip to main content link for accessibility -->
    <a href="#main-content" class="sr-only sr-only-focusable">Skip to main content</a>
    
    <%@ include file="/WEB-INF/jsps/partials/navbar.jspf" %>
    <div class="container min-vh-100 d-flex flex-column justify-content-center align-items-center" id="main-content">
      <div class="card shadow-sm summary-card w-100">
        <div class="card-body">
          <div class="mb-3 text-center">
            <h1 class="page-heading mb-2">
              <i class="bi bi-bar-chart-fill text-primary me-2" aria-hidden="true"></i>
              <span class="brand-main">Stock</span><span class="brand-accent">Trader</span> Portfolio Summary
            </h1>
          </div>
          <img src="<%=headerImage%>" alt="StockTrader header image with golden bull on blue background" class="summary-header-img mb-3" loading="eager"/>
          <div class="mb-4"></div>
          <% if(request.getAttribute("error") != null && ((Boolean)request.getAttribute("error")).booleanValue() == true) { %>
            <div class="alert alert-danger" role="alert" aria-live="assertive">
              <i class="bi bi-exclamation-triangle-fill me-2" aria-hidden="true"></i>
              Error communicating with the Broker microservice: ${message}<br/>
              Please consult the <i>trader</i>, <i>broker</i> and <i>portfolio</i> pod logs for more details, or ask your administator for help.
            </div>
          <% } else { %>
            <% List<Broker> brokers = (List<Broker>)request.getAttribute("brokers"); %>
            <% boolean noPortfolios = (brokers != null && brokers.isEmpty()); %>
            <% if(request.isUserInRole("StockTrader")) { %>
              <div class="mb-3 text-end">
                <form method="post" style="display:inline;">
                  <input type="hidden" name="action" value="create"/>
                  <button type="submit" name="submit" value="Submit" class="btn btn-success" aria-describedby="create-portfolio-help">
                    <i class="bi bi-plus-circle me-1" aria-hidden="true"></i> Create Portfolio
                  </button>
                </form>
                <div id="create-portfolio-help" class="sr-only">Create a new investment portfolio</div>
              </div>
            <% } %>
            <% if (noPortfolios) { %>
              <div class="alert alert-info mt-2" role="alert" aria-live="polite">
                <i class="bi bi-info-circle me-2" aria-hidden="true"></i>
                You don't have any portfolios yet. Create one to get started!
              </div>
            <% } %>
            <% if (brokers != null && !brokers.isEmpty()) { %>
              <div class="table-responsive mb-3">
                <table class="table table-bordered align-middle table-hover text-center" role="table" aria-label="Portfolio summary table">
                  <thead class="table-light">
                    <tr>
                      <th scope="col"><i class="bi bi-person" aria-hidden="true"></i> Owner</th>
                      <th scope="col"><i class="bi bi-cash-stack" aria-hidden="true"></i> Total</th>
                      <th scope="col"><i class="bi bi-award" aria-hidden="true"></i> Loyalty Level</th>
                      <th scope="col" class="text-center">Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <% for (int index=0; index<brokers.size(); index++) { 
                      Broker broker = brokers.get(index);
                      String owner = broker.getOwner();
                      Utilities.logToS3(owner, broker);
                      String loyalty = broker.getLoyalty();
                      String badgeClass = "bg-light text-dark border";
                      if (loyalty != null) {
                        if (loyalty.equalsIgnoreCase("Platinum")) badgeClass = "bg-primary";
                        else if (loyalty.equalsIgnoreCase("Gold")) badgeClass = "bg-warning text-dark";
                        else if (loyalty.equalsIgnoreCase("Silver")) badgeClass = "bg-secondary";
                        else if (loyalty.equalsIgnoreCase("Bronze")) badgeClass = "bg-light text-dark border";
                      }
                    %>
                      <tr>
                        <td><%=owner%></td>
                        <td>$<%=currency.format(broker.getTotal())%></td>
                        <td><span class="badge <%=badgeClass%>" aria-label="Loyalty level: <%=loyalty%>"><%=loyalty%></span></td>
                        <td>
                          <!-- Desktop: Individual buttons -->
                          <div class="btn-group d-none d-md-flex" role="group" aria-label="Actions for <%=owner%>'s portfolio">
                            <form method="post" style="display:inline;" class="me-1">
                              <input type="hidden" name="action" value="retrieve"/>
                              <input type="hidden" name="owner" value="<%=owner%>"/>
                              <button type="submit" name="submit" value="Submit" class="btn btn-view btn-sm" 
                                      aria-label="View <%=owner%>'s portfolio">
                                <i class="bi bi-eye" aria-hidden="true"></i>
                              </button>
                            </form>
                            <form method="post" style="display:inline;" class="me-1">
                              <input type="hidden" name="action" value="update"/>
                              <input type="hidden" name="owner" value="<%=owner%>"/>
                              <button type="submit" name="submit" value="Submit" class="btn btn-update btn-sm"
                                      aria-label="Update <%=owner%>'s portfolio">
                                <i class="bi bi-pencil" aria-hidden="true"></i>
                              </button>
                            </form>
                            <form method="post" style="display:inline;">
                              <input type="hidden" name="action" value="delete"/>
                              <input type="hidden" name="owner" value="<%=owner%>"/>
                              <button type="submit" name="submit" value="Submit" class="btn btn-delete btn-sm"
                                      aria-label="Delete <%=owner%>'s portfolio"
                                      onclick="return confirm('Are you sure you want to delete <%=owner%>\'s portfolio?')">
                                <i class="bi bi-trash" aria-hidden="true"></i>
                              </button>
                            </form>
                          </div>
                          
                          <!-- Mobile: Dropdown menu -->
                          <div class="dropdown d-md-none">
                            <button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" 
                                    data-bs-toggle="dropdown" aria-expanded="false"
                                    aria-label="Actions for <%=owner%>'s portfolio">
                              <i class="bi bi-three-dots" aria-hidden="true"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                              <li>
                                <form method="post" style="display:inline;">
                                  <input type="hidden" name="action" value="retrieve"/>
                                  <input type="hidden" name="owner" value="<%=owner%>"/>
                                  <button type="submit" name="submit" value="Submit" class="dropdown-item"
                                          aria-label="View <%=owner%>'s portfolio">
                                    <i class="bi bi-eye me-2" aria-hidden="true"></i>View
                                  </button>
                                </form>
                              </li>
                              <li>
                                <form method="post" style="display:inline;">
                                  <input type="hidden" name="action" value="update"/>
                                  <input type="hidden" name="owner" value="<%=owner%>"/>
                                  <button type="submit" name="submit" value="Submit" class="dropdown-item"
                                          aria-label="Update <%=owner%>'s portfolio">
                                    <i class="bi bi-pencil me-2" aria-hidden="true"></i>Update
                                  </button>
                                </form>
                              </li>
                              <li><hr class="dropdown-divider"></li>
                              <li>
                                <form method="post" style="display:inline;">
                                  <input type="hidden" name="action" value="delete"/>
                                  <input type="hidden" name="owner" value="<%=owner%>"/>
                                  <button type="submit" name="submit" value="Submit" class="dropdown-item text-danger"
                                          aria-label="Delete <%=owner%>'s portfolio"
                                          onclick="return confirm('Are you sure you want to delete <%=owner%>\'s portfolio?')">
                                    <i class="bi bi-trash me-2" aria-hidden="true"></i>Delete
                                  </button>
                                </form>
                              </li>
                            </ul>
                          </div>
                        </td>
                      </tr>
                    <% } %>
                  </tbody>
                </table>
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
    <script src="${pageContext.request.contextPath}/js/summary.js"></script>
  </body>
</html>
