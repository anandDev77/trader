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

        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        Principal user = request.getUserPrincipal();
        out.println("principal=" + (user == null ? "<null>" : user.getName()));
        out.println("role.StockTrader=" + request.isUserInRole("StockTrader"));
        out.println("role.StockViewer=" + request.isUserInRole("StockViewer"));

        String accessToken = (String) request.getAttribute("com.ibm.websphere.security.oidc.access_token");
        String idToken     = (String) request.getAttribute("com.ibm.websphere.security.oidc.id_token");
        HttpSession session = request.getSession(false);
        String sessionJwt = session == null ? null : (String) session.getAttribute("jwt");

        out.println("has.access_token.attr=" + (accessToken != null));
        out.println("has.id_token.attr=" + (idToken != null));
        out.println("has.session.jwt=" + (sessionJwt != null));

        tryDecode("id_token", idToken, out);
        tryDecode("access_token", accessToken, out);
        tryDecode("session_jwt", sessionJwt, out);
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


