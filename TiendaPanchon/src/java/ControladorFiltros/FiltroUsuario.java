package ControladorFiltros;

import java.io.IOException;
import javax.servlet.DispatcherType;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import modelo.entidades.Usuario;

/**
 *
 * @author Panchon
 *
 */
@WebFilter(
        filterName = "FiltroUsuario",
        urlPatterns = {"/*"},
        dispatcherTypes = {
            DispatcherType.REQUEST,
            DispatcherType.FORWARD,
            DispatcherType.ERROR,
            DispatcherType.INCLUDE
        }
)
public class FiltroUsuario implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String contexto = req.getContextPath();
        HttpSession sesion = req.getSession(false);
        Usuario usuario = (sesion != null) ? (Usuario) sesion.getAttribute("usuario") : null;

        // Permitir recursos estáticos
        boolean accesoPermitido = uri.matches(".*\\.(css|js|png|jpg|jpeg|gif|woff|ttf|svg|ico)$");

        // Permitir rutas públicas
        accesoPermitido = accesoPermitido || (uri.equals(contexto + "/")
                || uri.equals(contexto + "/index.jsp")
                || uri.equals(contexto + "/index.html")
                || uri.equals(contexto + "/login.jsp")
                || uri.equals(contexto + "/registro.jsp")
                || uri.equals(contexto + "/usuarios/inicio.jsp")
                || // vista tras login o registro
                uri.equals(contexto + "/Controladores/ControladorLogin")
                || uri.equals(contexto + "/Controladores/ControladorInicio")
                || (uri.equals(contexto + "/Controladores.Usuarios/ControladorUsuarios") && req.getParameter("crear") != null)
                || uri.startsWith(contexto + "/Controladores.Productos/ControladorListarProductos"));

        if (accesoPermitido) {
            chain.doFilter(request, response);
            return;
        }

        if (usuario != null) {
            chain.doFilter(request, response);
            return;
        }

// Detectar si es petición AJAX
        boolean esAjax = "XMLHttpRequest".equals(req.getHeader("X-Requested-With"));

        if (esAjax) {
            System.out.println("[FILTRO] Petición AJAX sin sesión. Devolviendo 401.");
            res.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            res.getWriter().write("No autorizado");
        } else {
            System.out.println("[FILTRO] Petición normal sin sesión. Redirigiendo a login.");
            res.sendRedirect(contexto + "/Controladores/ControladorLogin");
        }

    }
}
