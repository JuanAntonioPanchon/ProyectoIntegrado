/*
 * ControladorGestionarUsuarios
 * Listará a todos los usuarios del programa, se podrán editar y eliminar
 */
package Controladores.Admin;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.entidades.Usuario;
import modelo.servicio.ServicioUsuario;
import modelo.servicio.exceptions.NonexistentEntityException;

@WebServlet(name = "ControladorGestionarUsuarios", urlPatterns = {"/Controladores.Admin/ControladorGestionarUsuarios"})
public class ControladorGestionarUsuarios extends HttpServlet {

    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
    private ServicioUsuario servicioUsuario = new ServicioUsuario(emf);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String vista = "/admin/listarUsuarios.jsp";
        String accion = request.getParameter("accion");
        String error = "";

        if ("crear".equals(accion)) {
            request.setAttribute("usuario", new Usuario());
            vista = "/admin/crearUsuario.jsp";
        } else if ("editar".equals(accion)) {
            Long idUsuario = Long.parseLong(request.getParameter("idUsuario"));
            Usuario usuario = servicioUsuario.findUsuario(idUsuario);
            if (usuario != null) {
                request.setAttribute("usuario", usuario);
                vista = "/admin/crearUsuario.jsp";
            } else {
                error = "Usuario no encontrado.";
                request.setAttribute("error", error);
            }
        } else if ("Eliminar".equals(accion)) {
            Long idUsuario = Long.parseLong(request.getParameter("idUsuario"));
            try {
                servicioUsuario.destroy(idUsuario);
                response.sendRedirect(request.getContextPath() + "/Controladores.Admin/ControladorGestionarUsuarios");
                return;
            } catch (NonexistentEntityException e) {
                error = "El usuario no existe.";
                request.setAttribute("error", error);
            }
        }

        int pagina = 1;
        int tamanio = 10;

        if (request.getParameter("pagina") != null) {
            try {
                pagina = Integer.parseInt(request.getParameter("pagina"));
            } catch (NumberFormatException e) {
                pagina = 1;
            }
        }

        List<Usuario> usuarios = servicioUsuario.findUsuarioEntitiesPaginado(pagina, tamanio);
        long total = servicioUsuario.contarUsuarios();
        int totalPaginas = (int) Math.ceil((double) total / tamanio);

        request.setAttribute("usuarios", usuarios);
        request.setAttribute("paginaActual", pagina);
        request.setAttribute("totalPaginas", totalPaginas);

        getServletContext().getRequestDispatcher(vista).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String vista = "/admin/crearUsuario.jsp";
        String error = "";
        String accion = request.getParameter("accion");
        Long idUsuario = null;

        // Eliminar Usuario
        if ("Eliminar".equals(accion)) {
            idUsuario = Long.parseLong(request.getParameter("idUsuario"));
            String pagina = request.getParameter("pagina");
            if (pagina == null || pagina.isEmpty()) {
                pagina = "1";
            }
            try {
                servicioUsuario.destroy(idUsuario);
                response.sendRedirect(request.getContextPath() + "/Controladores.Admin/ControladorGestionarUsuarios?pagina=" + pagina);
                return;
            } catch (NonexistentEntityException e) {
                error = "El usuario no existe.";
                request.setAttribute("error", error);
            }
        }

        // Crear / Editar
        String nombre = request.getParameter("nombre");
        String apellidos = request.getParameter("apellidos");
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String password2 = request.getParameter("password2");
        String rolStr = request.getParameter("rol");

        // Editar
        if (request.getParameter("idUsuario") != null && !request.getParameter("idUsuario").isEmpty()) {
            idUsuario = Long.parseLong(request.getParameter("idUsuario"));
        }

        // Crear si no existe
        Usuario usuario = idUsuario != null ? servicioUsuario.findUsuario(idUsuario) : new Usuario();

        // Comprobación del email solo si estamos creando un nuevo usuario
        if (idUsuario == null && servicioUsuario.findUsuarioByEmail(email) != null) {
            error = "El email ya está registrado.";
            request.setAttribute("error", error);
        }

        // Establecer el rol
        try {
            if (rolStr != null && !rolStr.isEmpty()) {
                usuario.setRol(modelo.entidades.RolEnum.valueOf(rolStr));
            } else {
                usuario.setRol(modelo.entidades.RolEnum.normal); // Rol por defecto sera normal
            }
        } catch (IllegalArgumentException e) {
            error = "Rol no válido.";
            request.setAttribute("error", error);
        }

        // Validar contraseñas
        if (password != null && !password.isEmpty() && password.equals(password2)) {
            usuario.setPassword(password);
        } else {
            error = "Las contraseñas no coinciden.";
            request.setAttribute("error", error);
        }

        usuario.setNombre(nombre);
        usuario.setApellidos(apellidos);
        usuario.setDireccion(direccion);
        usuario.setTelefono(telefono);
        usuario.setEmail(email);

        if (error.isEmpty()) {
            try {
                // Si no tiene id (nuevo usuario), lo creamos, si lo tiene (editar), lo editamos
                if (idUsuario == null) {
                    servicioUsuario.create(usuario);
                } else {
                    servicioUsuario.edit(usuario);
                }
                String pagina = request.getParameter("pagina");
                if (pagina == null || pagina.isEmpty()) {
                    pagina = "1";
                }
                response.sendRedirect(request.getContextPath() + "/Controladores.Admin/ControladorGestionarUsuarios?pagina=" + pagina);

                return;
            } catch (Exception e) {
                error = "Error al guardar el usuario.";
            }
        }

        request.setAttribute("error", error);

        request.setAttribute("usuario", usuario);
        getServletContext().getRequestDispatcher(vista).forward(request, response);
    }

}
