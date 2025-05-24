/*
 * ControladorUsuarios
 */
package Controladores.Usuarios;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import modelo.entidades.Usuario;
import modelo.entidades.RolEnum;
import modelo.servicio.ServicioUsuario;
import modelo.servicio.exceptions.NonexistentEntityException;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author juan-antonio
 */
@WebServlet(name = "ControladorUsuarios", urlPatterns = {"/Controladores.Usuarios/ControladorUsuarios"})
public class ControladorUsuarios extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
        ServicioUsuario su = new ServicioUsuario(emf);
        String vista = "/registrado.jsp";

        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuario");

        if (request.getParameter("crear") != null) {
            vista = "/registro.jsp";
        } else if (usuario != null) {
            try {
                request.setAttribute("idUsuario", usuario.getId());
                request.setAttribute("nombre", usuario.getNombre());
                request.setAttribute("apellidos", usuario.getApellidos());
                request.setAttribute("email", usuario.getEmail());
                request.setAttribute("direccion", usuario.getDireccion());
                request.setAttribute("telefono", usuario.getTelefono());

                request.setAttribute("rol", usuario.getRol() != null ? usuario.getRol().name() : "normal");
                vista = "/registro.jsp";
            } catch (Exception e) {
                request.setAttribute("error", "Error al cargar el usuario.");
            }
        }

        emf.close();
        getServletContext().getRequestDispatcher(vista).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String nombre = request.getParameter("nombre");
        String apellidos = request.getParameter("apellidos");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String password2 = request.getParameter("password2");
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");
        String rolStr = request.getParameter("rol");

        String vista = "/registro.jsp";
        String error = "";

        EntityManagerFactory emf = Persistence.createEntityManagerFactory("TiendaPanchonPU");
        ServicioUsuario su = new ServicioUsuario(emf);
        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuario");

        RolEnum rol = null;
        if (rolStr != null && !rolStr.isEmpty()) {
            try {
                rol = RolEnum.valueOf(rolStr);
            } catch (IllegalArgumentException e) {
                error = "Rol no válido.";
            }
        }

        // CREAR USUARIO
        if (request.getParameter("crear") != null) {
            try {
                if (su.findUsuarioByEmail(email) != null) {
                    error = "El email ya está registrado, prueba con otro";
                }

                if (error.isEmpty() && !password.equals(password2)) {
                    error = "Las contraseñas no coinciden.";
                }

                if (error.isEmpty()) {
                    Usuario nuevoUsuario = new Usuario();
                    nuevoUsuario.setNombre(nombre);
                    nuevoUsuario.setApellidos(apellidos);
                    nuevoUsuario.setEmail(email);
                    nuevoUsuario.setDireccion(direccion);
                    nuevoUsuario.setTelefono(telefono);
                    nuevoUsuario.setRol(rol != null ? rol : RolEnum.normal);

                    String hash = BCrypt.hashpw(password, BCrypt.gensalt());
                    nuevoUsuario.setPassword(hash);

                    su.create(nuevoUsuario);
                    sesion.setAttribute("usuario", nuevoUsuario);
                    response.sendRedirect(request.getContextPath() + "/Controladores/ControladorLogin");
                    emf.close();
                    return;
                }

            } catch (Exception e) {
                error = "Error al crear el usuario " + nombre;
            }
        } // EDITAR USUARIO
        else if (request.getParameter("editar") != null && usuario != null) {
            try {
                Usuario existente = su.findUsuarioByEmail(email);
                if (existente != null && !existente.getId().equals(usuario.getId())) {
                    error = "El email ya está registrado por otro usuario.";
                }

                if (error.isEmpty()) {
                    usuario.setEmail(email);
                    usuario.setNombre(nombre);
                    usuario.setApellidos(apellidos);
                    usuario.setDireccion(direccion);
                    usuario.setTelefono(telefono);
                    usuario.setRol(rol);

                    if (!password.isBlank() || !password2.isBlank()) {
                        if (password.equals(password2)) {
                            String hash = BCrypt.hashpw(password, BCrypt.gensalt());
                            usuario.setPassword(hash);
                        } else {
                            error = "Las contraseñas no coinciden.";
                        }
                    }

                    if (error.isEmpty()) {
                        su.edit(usuario);
                        sesion.setAttribute("usuario", usuario);
                        response.sendRedirect(request.getContextPath() + "/Controladores/ControladorInicio");
                        emf.close();
                        return;
                    }
                }

            } catch (Exception ex) {
                error = "Error al editar el usuario.";
                Logger.getLogger(ControladorUsuarios.class.getName()).log(Level.SEVERE, null, ex);
            }
        } // ELIMINAR USUARIO
        else if (request.getParameter("eliminar") != null) {
            Long id = Long.parseLong(request.getParameter("idUsuario"));
            try {
                su.destroy(id);
                sesion.invalidate();
                response.sendRedirect(request.getContextPath() + "/Controladores/ControladorLogin");
                emf.close();
                return;
            } catch (NonexistentEntityException e) {
                error = "El usuario ya no existe.";
            } catch (Exception e) {
                error = "No se puede eliminar el usuario.";
                Logger.getLogger(ControladorUsuarios.class.getName()).log(Level.SEVERE, null, e);
            }

            if (!error.isEmpty()) {
                sesion.setAttribute("error", error);
                response.sendRedirect(request.getContextPath() + "/Controladores/ControladorLogin");
                emf.close();
                return;
            }
        }

        request.setAttribute("error", error);
        request.setAttribute("nombre", nombre);
        request.setAttribute("apellidos", apellidos);
        request.setAttribute("email", email);
        request.setAttribute("direccion", direccion);
        request.setAttribute("telefono", telefono);
        request.setAttribute("rol", rol != null ? rol.name() : "normal");

        emf.close();
        getServletContext().getRequestDispatcher(vista).forward(request, response);
    }
}
