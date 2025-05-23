<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>${empty usuario.id ? "Crear" : "Editar"} Usuario</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" href="../estilos/tablas.css">
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script&display=swap" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
    <body class="colorFondo text-dark">

        <jsp:include page="/includes/header.jsp" />

        <main class="container my-5">
            <div class="p-4 mx-auto border rounded shadow-lg form-container" style="max-width: 500px;">
                <h2 class="text-center fw-bold text-uppercase">
                    ${empty usuario.id ? "CREAR" : "EDITAR"} USUARIO
                </h2>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger mt-3 text-center fw-bold">${error}</div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/Controladores.Admin/ControladorGestionarUsuarios" id="formAdminUsuario">
                    <c:if test="${usuario != null}">
                        <input type="hidden" name="idUsuario" value="${usuario.id}">
                    </c:if>

                    <input type="hidden" name="tipo" value="usuario">

                    <div class="mb-2">
                        <label class="form-label fw-bold">NOMBRE</label>
                        <input type="text" class="form-control" name="nombre" value="${usuario.nombre}" maxlength="20" required>
                    </div>

                    <div class="mb-2">
                        <label class="form-label fw-bold">APELLIDOS</label>
                        <input type="text" class="form-control" name="apellidos" value="${usuario.apellidos}" maxlength="20" required>
                    </div>

                    <div class="mb-2">
                        <label class="form-label fw-bold">DIRECCIÓN</label>
                        <input type="text" class="form-control" name="direccion" value="${usuario.direccion}" maxlength="100" required>
                    </div>

                    <div class="mb-2">
                        <label class="form-label fw-bold">TELÉFONO</label>
                        <input type="text" class="form-control" name="telefono" value="${usuario.telefono}" maxlength="9" required>
                    </div>

                    <div class="mb-2">
                        <label class="form-label fw-bold">EMAIL</label>
                        <input type="email" class="form-control" name="email" value="${usuario.email}" maxlength="50" required>
                    </div>

                    <div class="mb-2">
                        <label class="form-label fw-bold">CONTRASEÑA</label>
                        <input type="password" class="form-control" name="password" value="${usuario.password}" maxlength="30" required>
                    </div>

                    <ul id="requisitosPassword" class="small mb-2">
                        <li class="text-danger">Al menos una letra mayúscula</li>
                        <li class="text-danger">Al menos un número</li>
                        <li class="text-danger">Al menos un símbolo</li>
                        <li class="text-danger">Al menos 8 caracteres</li>
                    </ul>

                    <div class="mb-2">
                        <label class="form-label fw-bold">REPETIR CONTRASEÑA</label>
                        <input type="password" class="form-control" name="password2" value="${usuario.password}" maxlength="30" required>
                        <div id="feedbackPassword2" class="small mt-1"></div>
                    </div>

                    <div class="mb-2">
                        <label class="form-label fw-bold">ROL</label>
                        <select class="form-select" name="rol">
                            <option value="normal" ${usuario.rol == 'normal' ? 'selected' : ''}>Normal</option>
                            <option value="admin" ${usuario.rol == 'admin' ? 'selected' : ''}>Admin</option>
                        </select>
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <a href="${pageContext.request.contextPath}/Controladores.Admin/ControladorGestionarUsuarios" class="btn btn-volver px-4">Cancelar</a>
                        <button type="button" class="btn btn-crear px-4" id="btnAceptar">Aceptar</button>
                    </div>
                </form>
            </div>
        </main>

        <jsp:include page="/includes/footer.jsp" />

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const form = document.getElementById("formAdminUsuario");
                const campos = {
                    nombre: {
                        regex: /^[A-ZÁÉÍÓÚÑ][A-Za-zÁÉÍÓÚÑáéíóúñü ]{0,19}$/,
                        mensaje: "Debe empezar con mayúscula. Máx. 20 letras y espacios."
                    },
                    apellidos: {
                        regex: /^[A-ZÁÉÍÓÚÑ][A-Za-zÁÉÍÓÚÑáéíóúñü ]{0,19}$/,
                        mensaje: "Debe empezar con mayúscula. Máx. 20 letras y espacios."
                    },
                    direccion: {
                        regex: /^(?=.*\d)[A-Za-z0-9ÁÉÍÓÚÑáéíóúñü ,\/]{1,100}$/,
                        mensaje: "Debe tener letras, números, / o , y al menos un número."
                    },
                    telefono: {
                        regex: /^[679][0-9]{8}$/,
                        mensaje: "Debe tener 9 dígitos y empezar por 6, 7 o 9."
                    },
                    email: {
                        regex: /^[\w-.]+@[\w-]+\.[a-z]{2,}$/i,
                        mensaje: "Debe ser un email válido."
                    }
                };

                function crearMensajeError(input, mensaje) {
                    eliminarMensajeError(input);
                    const div = document.createElement("div");
                    div.className = "text-danger mt-1 small";
                    div.textContent = mensaje;
                    input.parentElement.appendChild(div);
                }

                function eliminarMensajeError(input) {
                    const viejo = input.parentElement.querySelector(".text-danger");
                    if (viejo)
                        viejo.remove();
                }

                function validarCampo(nombreCampo) {
                    const input = form[nombreCampo];
                    const {regex, mensaje} = campos[nombreCampo];
                    if (!regex.test(input.value.trim())) {
                        crearMensajeError(input, mensaje);
                        return false;
                    } else {
                        eliminarMensajeError(input);
                        return true;
                    }
                }

                Object.keys(campos).forEach(campo => {
                    const input = form[campo];
                    validarCampo(campo);
                    input.addEventListener("input", () => validarCampo(campo));
                });

                const passInput = form["password"];
                const pass2Input = form["password2"];
                const feedbackList = document.getElementById("requisitosPassword").children;

                const criterios = {
                    mayuscula: /[A-Z]/,
                    numero: /[0-9]/,
                    simbolo: /[^A-Za-z0-9]/,
                    longitud: /.{8,}/
                };

                function actualizarFeedbackPassword() {
                    Object.keys(criterios).forEach((key, i) => {
                        feedbackList[i].className = criterios[key].test(passInput.value) ? "text-success" : "text-danger";
                    });
                }

                const feedbackCoincidencia = document.getElementById("feedbackPassword2");

                function validarCoincidenciaPasswords() {
                    if (pass2Input.value === "") {
                        feedbackCoincidencia.textContent = "";
                        return;
                    }
                    if (passInput.value === pass2Input.value) {
                        feedbackCoincidencia.textContent = "Las contraseñas coinciden.";
                        feedbackCoincidencia.className = "text-success mt-1 small";
                    } else {
                        feedbackCoincidencia.textContent = "Las contraseñas no coinciden.";
                        feedbackCoincidencia.className = "text-danger mt-1 small";
                    }
                }

                passInput.addEventListener("input", () => {
                    actualizarFeedbackPassword();
                    validarCoincidenciaPasswords();
                });
                pass2Input.addEventListener("input", validarCoincidenciaPasswords);

                actualizarFeedbackPassword();
                validarCoincidenciaPasswords();

                const btnAceptar = document.getElementById("btnAceptar");

                btnAceptar.addEventListener("click", function (e) {
                    e.preventDefault();

                    let valido = true;
                    Object.keys(campos).forEach(campo => {
                        if (!validarCampo(campo))
                            valido = false;
                    });

                    actualizarFeedbackPassword();
                    validarCoincidenciaPasswords();

                    const passOk = Object.values(criterios).every(regex => regex.test(passInput.value));
                    const iguales = passInput.value === pass2Input.value;

                    if (!valido || !passOk || !iguales)
                        return;

                    const accion = '${empty usuario.id ? "crear" : "editar"}';
                    const nombre = form["nombre"].value.trim();

                    Swal.fire({
                        title: accion === 'crear' ? '¿Crear usuario?' : '¿Guardar cambios?',
                        text: accion === 'crear'
                                ? `¿Estás seguro de que quieres crear al usuario?`
                                : `Se modificarán los datos del usuario ¿Estás seguro de continuar?`,
                        icon: 'question',
                        showCancelButton: true,
                        confirmButtonColor: '#336b30',
                        cancelButtonText: 'No, volver',
                        confirmButtonText: 'Sí, continuar'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            const inputAccion = document.createElement('input');
                            inputAccion.type = 'hidden';
                            inputAccion.name = accion;
                            form.appendChild(inputAccion);
                            form.submit();
                        }
                    });
                });
            });
        </script>

    </body>
</html>
