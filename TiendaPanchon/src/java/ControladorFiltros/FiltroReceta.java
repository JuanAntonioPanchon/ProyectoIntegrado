/*
 * FiltroReceta.
 * Controla el acceso a todos los recursos de recetas a admin o usuarios
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
@WebFilter(filterName = "FiltroReceta", urlPatterns = {"/Controladores/*", "/receta/*", "/includes/*"}, dispatcherTypes = {DispatcherType.REQUEST, DispatcherType.FORWARD, DispatcherType.ERROR, DispatcherType.INCLUDE})
public class FiltroReceta implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession sesion = req.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuario");

        
        String path = req.getRequestURI();

        
        if (path.contains("/Controladores/ControladorLogin") || path.contains("/Controladores/ControladorInicio")) {
            chain.doFilter(request, response);
            return;
        }

        
        if (usuario == null || (!usuario.getRol().equals(RolEnum.normal) && !usuario.getRol().equals(RolEnum.admin))) {
            // Si no hay usuario registrado o no tiene el rol adecuado, redirige al login
            res.sendRedirect(req.getServletContext().getContextPath() + "/Controladores/ControladorLogin");
            return;
        }

        
        chain.doFilter(request, response);
    }
}
