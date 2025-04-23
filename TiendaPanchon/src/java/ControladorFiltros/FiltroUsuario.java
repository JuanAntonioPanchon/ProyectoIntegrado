/*
 * FiltroUsuario.
 * Controla el acceso a todos los recursos de usuario registrado.
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
 */
@WebFilter(filterName = "FiltroUsuario", urlPatterns = {"/carrito/*", "/listaCompra/*"}, dispatcherTypes = {DispatcherType.REQUEST, DispatcherType.FORWARD, DispatcherType.ERROR, DispatcherType.INCLUDE})
public class FiltroUsuario implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession sesion = req.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuario");
        if (usuario == null || !usuario.getRol().equals(RolEnum.normal)) {
            // Si no hay usuario registrado o no es administrador
            res.sendRedirect(req.getServletContext().getContextPath() + "/Controladores/ControladorLogin");
            return;
        }

        chain.doFilter(request, response);
    }

}
