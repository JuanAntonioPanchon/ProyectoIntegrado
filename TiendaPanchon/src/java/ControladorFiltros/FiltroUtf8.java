/*
* He tenido que añadir este filtro, porque tras introducir esta linea 
* request.setCharacterEncoding("UTF-8") no me salian las tildes ni las ñ al
* crear un usuario desde el registro ni al editarme el perfil, cosa que si
* hacia desde el admi. Por lo tanto la unica solucion ha sido esta.
*/

package ControladorFiltros;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;

@WebFilter("/*")
public class FiltroUtf8 implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        chain.doFilter(request, response);
    }
}
