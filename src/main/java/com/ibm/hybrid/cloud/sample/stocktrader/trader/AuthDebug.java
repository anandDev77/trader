package com.ibm.hybrid.cloud.sample.stocktrader.trader;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.Principal;
import java.util.Base64;
import java.util.logging.Logger;

@WebServlet(urlPatterns = { "/auth/debug" })
public class AuthDebug extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(AuthDebug.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // If no tokens yet, trigger the container OIDC flow for this endpoint
        String probeAccess = (String) request.getAttribute("com.ibm.websphere.security.oidc.access_token");
        String probeId     = (String) request.getAttribute("com.ibm.websphere.security.oidc.id_token");
        if ((probeAccess == null || probeAccess.isEmpty()) && (probeId == null || probeId.isEmpty())) {
            try {
                request.authenticate(response);
                return; // container will redirect; on return tokens will be present
            } catch (Throwable t) {
                // fall through and print error details below
            }
        }
        response.setContentType("text/plain;charset=UTF-8");
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        response.setHeader("Pragma", "no-cache");

        StringBuilder sb = new StringBuilder();
        Principal user = request.getUserPrincipal();
        sb.append("principal=").append(user == null ? "<null>" : user.getName()).append('\n');
        sb.append("role.StockTrader=").append(request.isUserInRole("StockTrader")).append('\n');
        sb.append("role.StockViewer=").append(request.isUserInRole("StockViewer")).append('\n');

        String accessToken = (String) request.getAttribute("com.ibm.websphere.security.oidc.access_token");
        String idToken     = (String) request.getAttribute("com.ibm.websphere.security.oidc.id_token");
        HttpSession session = request.getSession(false);
        String sessionJwt = session == null ? null : (String) session.getAttribute("jwt");

        sb.append("has.access_token.attr=").append(accessToken != null).append('\n');
        sb.append("has.id_token.attr=").append(idToken != null).append('\n');
        sb.append("has.session.jwt=").append(sessionJwt != null).append('\n');

        java.io.StringWriter sw = new java.io.StringWriter();
        java.io.PrintWriter out = new java.io.PrintWriter(sw);
        tryDecode("id_token", idToken, out);
        tryDecode("access_token", accessToken, out);
        tryDecode("session_jwt", sessionJwt, out);
        out.flush();
        sb.append(sw.toString());

        // log and write response
        logger.info(sb.toString());
        PrintWriter respOut = response.getWriter();
        respOut.write(sb.toString());
        respOut.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // After IdP callback (POST), reuse the same logic
        doGet(request, response);
    }

    private void tryDecode(String label, String token, PrintWriter out) {
        if (token == null || token.isEmpty()) {
            out.println(label + ": <empty>");
            return;
        }
        try {
            String[] parts = token.split("\\.");
            if (parts.length == 3) {
                String header = new String(Base64.getUrlDecoder().decode(parts[0]));
                String payload = new String(Base64.getUrlDecoder().decode(parts[1]));
                out.println(label + ".header=" + header);
                out.println(label + ".payload=" + payload);
            } else {
                out.println(label + ": not a JWS (parts=" + parts.length + ")");
            }
        } catch (Throwable t) {
            out.println(label + ": decode.error=" + t.getMessage());
        }
    }
}


