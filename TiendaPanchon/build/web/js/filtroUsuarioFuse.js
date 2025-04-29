/* 
 * Filtrar Usuarios con Fuse.js de manera dinamica
 */

document.addEventListener("DOMContentLoaded", () => {
                const buscador = document.getElementById("buscadorUsuarios");
                const tbody = document.getElementById("tablaUsuarios");

                const usuarios = [...tbody.querySelectorAll("tr")].map(row => {
                    const celdas = row.querySelectorAll("td");
                    return {
                        row: row,
                        nombre: celdas[0].textContent.trim(),
                        apellidos: celdas[1].textContent.trim(),
                        email: celdas[2].textContent.trim(),
                        rol: celdas[3].textContent.trim()
                    };
                });

                const fuse = new Fuse(usuarios, {
                    keys: ['nombre', 'apellidos', 'email', 'rol'],
                    threshold: 0.2,
                });

                buscador.addEventListener("input", () => {
                    const valor = buscador.value.trim();
                    tbody.innerHTML = "";

                    if (valor === "") {
                        usuarios.forEach(u => tbody.appendChild(u.row));
                    } else {
                        const resultados = fuse.search(valor);
                        resultados.forEach(result => {
                            tbody.appendChild(result.item.row);
                        });
                    }
                });
            });
