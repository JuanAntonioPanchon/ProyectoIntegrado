/*
 * Servlet ControladorLogin
 */
package Controladores;

import java.io.IOException;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import modelo.entidades.RolEnum;
import modelo.entidades.Usuario;
import modelo.servicio.ServicioUsuario;

/**
 *
 * @author juan-antonio
 */
@WebServlet(name = "ControladorLogin", urlPatterns = {"/Controladores/ControladorLogin"})
public class ControladorLogin extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if ("logout".equals(accion)) {
            HttpSession sesion = request.getSession(false); // Obtener la sesi�n actual sin crear una nueva
            if (sesion != null) {
                sesion.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/Controladores/ControladorLogin");
        } else {
            getServletContext().getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String error = "";

        if (email == null || password == null || email.isEmpty() || password.isEmpty()) {
            error = "El e-mail y la constraseña son obligatorias";
        } else {
            EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
            ServicioUsuario su = new ServicioUsuario(emf);
            Usuario usu = su.validarUsuario(email, password);
            if (usu != null) {
                HttpSession sesion = request.getSession();
                sesion.setAttribute("usuario", usu);
                if (usu.getRol() == RolEnum.normal) {
                    response.sendRedirect("ControladorInicio");
                    return;
                } else if (usu.getRol() == RolEnum.admin)  {
                    response.sendRedirect("../Controladores.Admin/ControladorAdmin");
                    return;
                }

            } else {
                error = "e-mail o contraseña incorrecta";
            }
            emf.close();
        }
        request.setAttribute("error", error);
        
        getServletContext().getRequestDispatcher("/login.jsp").forward(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
