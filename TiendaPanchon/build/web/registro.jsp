<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Experiencias de Viaje</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="../estilos/coloresPersonalizados.css">
        <link rel="stylesheet" href="../estilos/registroUsuarios.css">
        <link rel="stylesheet" href="../estilos/tablas.css">
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script&display=swap" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
    <body>

        <c:if test="${not empty idUsuario}">
            <jsp:include page="/includes/headerUsuario.jsp" />
        </c:if>

        <main>
            <section>
                <div class="form-container mx-auto p-3 shadow rounded-4 my-4">

                    <div class="d-flex align-items-center mb-3">
                        <img src="../imagenes/elRinconDeLaura.jpeg" alt="Laura" class="me-3 rounded-circle logoTienda">
                        <c:if test="${not empty idUsuario}">
                            <h1 class="h4 fw-bold mb-0">Editar Usuario</h1>
                        </c:if>
                        <c:if test="${empty idUsuario}">
                            <h1 class="h4 fw-bold mb-0">Registrar Usuario</h1>
                        </c:if>
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/Controladores.Usuarios/ControladorUsuarios">
                        <c:if test="${not empty idUsuario}">
                            <input type="hidden" name="idUsuario" value="${idUsuario}">
                        </c:if>
                        <input type="hidden" name="tipo" value="usuario">

                        <div class="mb-2">
                            <label for="nombre" class="form-label">Nombre</label>
                            <input type="text" class="form-control form-control-sm" name="nombre" value="${nombre}" maxlength="20" required>
                        </div>

                        <div class="mb-2">
                            <label for="apellidos" class="form-label">Apellidos</label>
                            <input type="text" class="form-control form-control-sm" name="apellidos" value="${apellidos}" maxlength="20" required>
                        </div>

                        <div class="mb-2">
                            <label for="direccion" class="form-label">Dirección</label>
                            <input type="text" class="form-control form-control-sm" name="direccion" value="${direccion}" maxlength="100" required>
                        </div>

                        <div class="mb-2">
                            <label for="telefono" class="form-label">Teléfono</label>
                            <input type="text" class="form-control form-control-sm" name="telefono" value="${telefono}" maxlength="9" required>
                        </div>

                        <div class="mb-2">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control form-control-sm" name="email" value="${email}" maxlength="50" required>
                        </div>

                        <div class="mb-2">
                            <label for="password" class="form-label">Contraseña</label>
                            <input type="password" class="form-control form-control-sm" name="password" value=""
                                   maxlength="30"
                                   <c:if test="${empty idUsuario}">required</c:if>>
                            <c:if test="${not empty idUsuario}">
                                <div class="form-text">Si no deseas cambiar la contraseña, deja este campo vacío.</div>
                            </c:if>
                        </div>


                        <ul id="requisitosPassword" class="small mb-2 d-none">
                            <li class="text-danger">Al menos una letra mayúscula</li>
                            <li class="text-danger">Al menos un número</li>
                            <li class="text-danger">Al menos un símbolo</li>
                            <li class="text-danger">Al menos 8 caracteres</li>
                        </ul>

                        <div class="mb-2">
                            <label for="password2" class="form-label">Repetir Contraseña</label>
                            <input type="password" class="form-control form-control-sm" name="password2" value=""
                                   maxlength="30"
                                   <c:if test="${empty idUsuario}">required</c:if>>
                                   <div id="feedbackPassword2" class="small mt-1"></div>
                            <c:if test="${not empty idUsuario}">
                                <div class="form-text">Solo si cambias la contraseña, repítela aquí.</div>
                            </c:if>
                        </div>


                        <input type="hidden" name="rol" value="normal">

                        <div class="row mt-3 text-center">
                            <div class="col-4 d-flex justify-content-start">
                                <c:choose>
                                    <c:when test="${empty idUsuario}">
                                        <!-- Si está creando (registro) -->
                                        <a href="${pageContext.request.contextPath}/Controladores/ControladorLogin"
                                           class="btn btn-volver btn-sm botones">Cancelar</a>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Si está editando -->
                                        <a href="${pageContext.request.contextPath}/Controladores/ControladorInicio"
                                           class="btn btn-volver btn-sm botones">Cancelar</a>
                                    </c:otherwise>
                                </c:choose>
                            </div>


                            <div class="col-4 d-flex justify-content-center">
                                <button type="button"
                                        class="btn btn-crear btn-sm botones"
                                        onclick="confirmarEnvioFormulario('${empty idUsuario ? 'crear' : 'editar'}')">
                                    Aceptar
                                </button>

                            </div>

                            <div class="col-4 d-flex justify-content-end">
                                <c:if test="${not empty idUsuario}">
                                    <!-- Botón separado, fuera del form principal -->
                                    <button type="button"
                                            class="btn btn-eliminar btn-sm botones"
                                            onclick="confirmarEliminacion('${usuario.id}', '${usuario.nombre} ${usuario.apellidos}')">
                                        Eliminar
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </form>
                    <form id="formEliminarUsuario" method="post" action="ControladorUsuarios" style="display: none;">
                        <input type="hidden" name="idUsuario" id="inputEliminarIdUsuario">
                        <input type="hidden" name="eliminar" value="true">
                    </form>


                    <c:if test="${not empty error}">
                        <div class="text-danger text-center mt-2">${error}</div>
                    </c:if>

                </div>
            </section>
        </main>

        <jsp:include page="/includes/footer.jsp" /> 



        <script>
            function confirmarEliminacion(idUsuario, nombreCompleto) {
                Swal.fire({
                    title: `¿Deseas dar de baja?`,
                    text: "Los datos se eliminarán de forma permanente.",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: 'Sí, eliminar',
                    cancelButtonText: 'Cancelar'
                }).then((result) => {
                    if (result.isConfirmed) {
                        document.getElementById('inputEliminarIdUsuario').value = idUsuario;
                        document.getElementById('formEliminarUsuario').submit();
                    }
                });
            }

        </script>
        <script>
            function confirmarEnvioFormulario(accion) {
                const form = document.querySelector("form[action$='ControladorUsuarios']");
                const eventoSubmit = new Event('submit', {cancelable: true});
                const validado = form.dispatchEvent(eventoSubmit);

                if (!validado) {
                    return;
                }

                // Cambio de texto según si es "crear" o "editar"
                const esCrear = accion === 'crear';
                const titulo = esCrear ? '¿Deseas darte de alta?' : '¿Confirmar envío?';
                const texto = esCrear ? 'Se registrará un nuevo usuario con los datos proporcionados.' :
                        '¿Estás seguro de que deseas guardar los datos del usuario?';

                Swal.fire({
                    title: titulo,
                    text: texto,
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonText: esCrear ? 'Sí, registrarme' : 'Sí, guardar',
                    cancelButtonText: 'Cancelar',
                    confirmButtonColor: '#198754',
                    cancelButtonColor: '#6c757d'
                }).then((result) => {
                    if (result.isConfirmed) {
                        const inputAccion = document.createElement("input");
                        inputAccion.type = "hidden";
                        inputAccion.name = accion;
                        inputAccion.value = "Aceptar";
                        form.appendChild(inputAccion);
                        form.submit();
                    }
                });
            }

        </script>



        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const form = document.querySelector("form[action$='ControladorUsuarios']");
                const campos = {
                    nombre: {
                        regex: /^[A-ZÁÉÍÓÚÑ][A-Za-zÁÉÍÓÚÑáéíóúñü ]{0,19}$/,
                        mensaje: "Debe empezar con mayúscula. Puede contener letras, tildes y espacios. Máx. 20 caracteres."
                    },
                    apellidos: {
                        regex: /^[A-ZÁÉÍÓÚÑ][A-Za-zÁÉÍÓÚÑáéíóúñü ]{0,19}$/,
                        mensaje: "Debe empezar con mayúscula. Puede contener letras, tildes y espacios. Máx. 20 caracteres."
                    },
                    direccion: {
                        regex: /^(?=.*\d)[A-Za-z0-9ÁÉÍÓÚÑáéíóúñü ,\/]{1,100}$/,
                        mensaje: "Solo letras, números, / y , hasta 100 caracteres, y al menos un número."
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

                const keys = Object.keys(criterios);

                function actualizarFeedbackPassword() {
                    keys.forEach((k, i) => {
                        feedbackList[i].className = criterios[k].test(passInput.value) ? "text-success" : "text-danger";
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
                    const requisitos = document.getElementById("requisitosPassword");
                    if (passInput.value.trim() !== "") {
                        requisitos.classList.remove("d-none");
                    } else {
                        requisitos.classList.add("d-none");
                    }
                    actualizarFeedbackPassword();
                    validarCoincidenciaPasswords();
                });
                pass2Input.addEventListener("input", validarCoincidenciaPasswords);

                form.addEventListener("submit", function (e) {
                    let valido = true;
                    Object.keys(campos).forEach(campo => {
                        if (!validarCampo(campo))
                            valido = false;
                    });

                    actualizarFeedbackPassword();
                    validarCoincidenciaPasswords();

                    const esNuevo = document.querySelector('input[name="idUsuario"]') === null;
                    const passVacio = passInput.value.trim() === "" && pass2Input.value.trim() === "";

                    if (esNuevo || !passVacio) {
                        const passOk = keys.every(k => criterios[k].test(passInput.value));
                        const iguales = passInput.value === pass2Input.value;

                        if (!passOk || !iguales) {
                            e.preventDefault();
                            return;
                        }
                    }

                    if (!valido) {
                        e.preventDefault();
                    }
                });

                actualizarFeedbackPassword();
                validarCoincidenciaPasswords();
            });
        </script>


    </body>
</html>
