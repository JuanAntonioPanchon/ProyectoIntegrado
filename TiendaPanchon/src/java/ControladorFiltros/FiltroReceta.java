/*
 * FiltroReceta.
 * Permite acceso a recursos de recetas para usuarios logueados (normal o admin)
 */
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
import modelo.entidades.RolEnum;
import modelo.entidades.Usuario;

/**
 *
 * @author Panchon
 *
 */
@WebFilter(
        filterName = "FiltroReceta",
        urlPatterns = {
            "/receta/*",
            "/Controladores/ControladorFiltrarRecetas",
            "/Controladores/ControladorListadoReceta",
            "/Controladores/ControladorReceta"
        },
        dispatcherTypes = {
            DispatcherType.REQUEST // Solo REQUEST para evitar bucles
        }
)
public class FiltroReceta implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession sesion = req.getSession(false);

        Usuario usuario = (sesion != null) ? (Usuario) sesion.getAttribute("usuario") : null;

        // ✅ Permitir acceso si usuario es admin o normal
        if (usuario != null
                && (usuario.getRol().equals(RolEnum.normal) || usuario.getRol().equals(RolEnum.admin))) {
            chain.doFilter(request, response);
            return;
        }

        // 🚫 Si no, redirigir al login
        res.sendRedirect(req.getContextPath() + "/Controladores/ControladorLogin");
    }
}
