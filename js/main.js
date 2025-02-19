const API_URL = "http://localhost:8000";
let token = localStorage.getItem("token");
let role = localStorage.getItem("role");
let username = localStorage.getItem("username");

// FUNCION REGISTRO
async function register() {
    const name = document.getElementById('register-name').value;
    const email = document.getElementById('register-email').value;
    const password = document.getElementById('register-password').value;

    try {
        const response = await fetch(`${API_URL}/api/register.php`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                nombre: name,
                email: email,
                password: password
            })
        });

        const result = await response.json();
        
        if (result.status === "success") {
            alert("Usuario registrado con éxito");
            window.location.href = "../public/index.html"; // Redirige al login
        } else {
            alert("Error al registrar: " + result.message);
        }
    } catch (error) {
        console.error("Error en el registro:", error);
        alert("Error en el registro, revisa la consola.");
    }
}

// FUNCION LOGIN
async function login() {
    const email = document.getElementById("login-email").value;
    const password = document.getElementById("login-password").value;

    try {
        const response = await fetch(`${API_URL}/api/login.php`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ email, password })
        });

        if (!response.ok) {
            throw new Error("Error al hacer la solicitud al servidor.");
        }

        const data = await response.json();

        if (data.token) {
            localStorage.setItem("token", data.token);
            localStorage.setItem("role", data.role);
            localStorage.setItem("username", data.username);

            token = data.token;
            role = data.role;
            username = data.username;

            window.location.href = "../public/inicio.html"; 
        } else {
            alert("Error: " + (data.error || "Ha ocurrido un error desconocido."));
        }
    } catch (error) {
        console.error("Error en login:", error);
        alert("No se pudo iniciar sesión. Por favor, revisa la consola para más detalles.");
    }
}

// FUNCION OBTENER PELÍCULAS DESDE LA API
async function getPeliculas() {
    try {
        const response = await fetch(`${API_URL}/api/peliculas.php`, {
            headers: {
                'Authorization': `Bearer ${token}` // Asegúrate de enviar el token de autorización
            }
        });
        const data = await response.json();

        if (data.status === "success" && data.peliculas.length > 0) {
            let container = document.getElementById("peliculas-container");

            if (!container) {
                console.error("No se encontró el contenedor de películas.");
                return;
            }

            container.innerHTML = ""; 

            data.peliculas.forEach((pelicula) => {
                let movieElement = document.createElement("div");
                movieElement.classList.add("pelicula");

                // Verificamos si la película está alquilada por el usuario y mostramos la fecha de devolución
                let alquilerMessage = "";
                if (pelicula.fecha_devolucion) {
                    alquilerMessage = `<p class="alquilada-msg">Alquilada hasta: ${pelicula.fecha_devolucion}</p>`;
                } else {
                    alquilerMessage = `<button class="alquilar-btn" onclick="alquilarPelicula(${pelicula.id})">Alquilar</button>`;
                }

                movieElement.innerHTML = `
                    <img src="${pelicula.poster}" alt="${pelicula.titulo}">
                    <h3>${pelicula.titulo}</h3>
                    <p>${pelicula.descripcion}</p>
                    ${alquilerMessage}  <!-- Aquí se inserta el botón o la fecha de devolución -->

                    <div id="resenas-${pelicula.id}"></div>
                    <button onclick="getResenas(${pelicula.id})">Ver Reseñas</button>
                    
                    <div class="resena-form">
                        <textarea id="resena-texto-${pelicula.id}" placeholder="Escribe una reseña"></textarea>
                        <select id="resena-calificacion-${pelicula.id}">
                            <option value="1">⭐</option>
                            <option value="2">⭐⭐</option>
                            <option value="3">⭐⭐⭐</option>
                            <option value="4">⭐⭐⭐⭐</option>
                            <option value="5">⭐⭐⭐⭐⭐</option>
                        </select>
                        <button onclick="agregarResena(${pelicula.id})">Agregar Reseña</button>
                    </div>
                `;
                container.appendChild(movieElement);
            });
        } else {
            console.error("No hay películas disponibles.");
            document.getElementById("peliculas-container").innerHTML = "<p>No se encontraron películas.</p>";
        }
    } catch (error) {
        console.error("Error al obtener películas:", error);
    }
}

// FUNCION DE BÚSQUEDA DE PELÍCULAS
function buscarPelicula() {
    const searchBar = document.getElementById("search-bar");
    searchBar.addEventListener("keyup", () => {
        const searchQuery = document.getElementById("search-bar").value.toLowerCase();
        const peliculas = document.querySelectorAll(".pelicula");
    
        peliculas.forEach(pelicula => {
            const titulo = pelicula.querySelector("h3").textContent.toLowerCase();
            pelicula.style.display = titulo.includes(searchQuery) ? "block" : "none";
        });
    });
}

// FUNCION ALQUILAR PELÍCULA
async function alquilarPelicula(peliculaId) {
    try {
        const response = await fetch(`${API_URL}/api/alquileres.php`, {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                pelicula_id: peliculaId
            })
        });
        
        const data = await response.json();

        alert(data.error || data.message); 
    } catch (error) {
        console.error("Hubo un error al alquilar la película:", error);
        alert("Hubo un error al alquilar la película.");
    }
}

// FUNCION OBTENER RESEÑAS
async function getResenas(peliculaId) {
    try {
        const response = await fetch(`${API_URL}/api/resenas.php?pelicula_id=${peliculaId}`, {
            method: "GET",
            headers: {
                "Authorization": `Bearer ${token}`, // 🔹 Agregamos el token aquí
                "Content-Type": "application/json"
            }
        });

        const text = await response.text();
        console.log("Respuesta cruda de la API:", text);

        const data = JSON.parse(text);
        let resenasContainer = document.getElementById(`resenas-${peliculaId}`);
        if (!resenasContainer) return;

        resenasContainer.innerHTML = "<h4>Reseñas:</h4>";

        if (data.resenas && data.resenas.length > 0) {
            data.resenas.forEach(resena => {
                let resenaElement = document.createElement("p");
                resenaElement.innerHTML = `⭐ ${resena.calificacion} - ${resena.comentario}`;
                resenasContainer.appendChild(resenaElement);
            });
        } else {
            resenasContainer.innerHTML += "<p>No hay reseñas aún.</p>";
        }
    } catch (error) {
        console.error("Error al obtener reseñas:", error);
    }
}

// FUNCION AGREGAR RESEÑA
async function agregarResena(peliculaId) {
    let resenaTexto = document.getElementById(`resena-texto-${peliculaId}`).value;
    let resenaCalificacion = document.getElementById(`resena-calificacion-${peliculaId}`).value;

    if (!resenaTexto) {
        alert("Escribe una reseña antes de enviarla.");
        return;
    }

    if (!resenaCalificacion || resenaCalificacion < 1 || resenaCalificacion > 5) {
        alert("La calificación debe estar entre 1 y 5.");
        return;
    }

    const resenaData = {
        pelicula_id: peliculaId,
        comentario: resenaTexto,
        calificacion: parseInt(resenaCalificacion)
    };

    console.log("Datos enviados:", resenaData);

    try {
        const response = await fetch(`${API_URL}/api/resenas.php`, {
            method: "POST",
            headers: {
                "Authorization": `Bearer ${token}`,
                "Content-Type": "application/json"
            },
            body: JSON.stringify(resenaData)
        });

        console.log("Código de respuesta:", response.status);

        const data = await response.json();
        console.log("Respuesta del servidor:", data);

        if (data.error) {
            alert(data.error); // 🔹 Muestra el mensaje de error si ya calificó la película
            return;
        }

        alert(data.message || "Reseña agregada con éxito");

        if (data.status === "success") {
            getResenas(peliculaId);
            document.getElementById(`resena-texto-${peliculaId}`).value = "";
            document.getElementById(`resena-calificacion-${peliculaId}`).value = "";
        }
    } catch (error) {
        console.error("Error al agregar reseña:", error);
        alert("Hubo un error al agregar la reseña. Revisa la consola.");
    }
}


// CERRAR SESIÓN
function logout() {
    localStorage.removeItem("token");
    localStorage.removeItem("role");
    localStorage.removeItem("username");
    token = null;
    role = null;
    username = null;
    window.location.href = "../public/index.html"; 
}

getPeliculas();
