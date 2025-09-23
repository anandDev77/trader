package com.ibm.hybrid.cloud.sample.stocktrader.trader;

import java.io.IOException;
import java.util.logging.Logger;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@WebFilter("/*")
public class OidcTokenCaptureFilter implements Filter {
    private static final String ACCESS_TOKEN_ATTR = "com.ibm.websphere.security.oidc.access_token";
    private static final String ID_TOKEN_ATTR = "com.ibm.websphere.security.oidc.id_token";
    private static final String SESSION_JWT = "jwt";

    private static final Logger logger = Logger.getLogger(OidcTokenCaptureFilter.class.getName());

    @Override
    public void init(FilterConfig filterConfig) throws ServletException { }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        if (request instanceof HttpServletRequest) {
            HttpServletRequest httpReq = (HttpServletRequest) request;
            String accessToken = (String) httpReq.getAttribute(ACCESS_TOKEN_ATTR);
            String idToken = (String) httpReq.getAttribute(ID_TOKEN_ATTR);

            if ((accessToken != null && !accessToken.isEmpty()) || (idToken != null && !idToken.isEmpty())) {
                HttpSession session = httpReq.getSession();
                if (session != null) {
                    String chosen = (accessToken != null && !accessToken.isEmpty()) ? accessToken : idToken;
                    session.setAttribute(SESSION_JWT, chosen);
                }
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() { }
}


