-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS videoclub;
USE videoclub;

-- Crear tabla de Usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Se almacenará con password_hash()
    rol ENUM('admin', 'cliente') DEFAULT 'cliente',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla de Películas
CREATE TABLE peliculas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_tmdb INT UNIQUE,
    titulo VARCHAR(255),
    descripcion TEXT,
    poster VARCHAR(255)
);


-- Crear tabla de Inventario de Películas
CREATE TABLE inventario_peliculas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pelicula_id INT NOT NULL,
    cantidad_disponible INT NOT NULL DEFAULT 1,
    FOREIGN KEY (pelicula_id) REFERENCES peliculas(id) ON DELETE CASCADE
);

-- Crear tabla de Alquileres
CREATE TABLE alquileres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    pelicula_id INT NOT NULL,
    fecha_alquiler TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_devolucion TIMESTAMP NULL,
    estado ENUM('Alquilada', 'Devuelta') DEFAULT 'Alquilada',
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (pelicula_id) REFERENCES peliculas(id) ON DELETE CASCADE
);

-- Crear tabla de Reseñas (para que los usuarios puedan calificar las películas)
CREATE TABLE resenas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    pelicula_id INT NOT NULL,
    calificacion INT CHECK (calificacion BETWEEN 1 AND 5), -- Calificación de 1 a 5 estrellas
    comentario TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (pelicula_id) REFERENCES peliculas(id) ON DELETE CASCADE
);

INSERT INTO peliculas (titulo, descripcion, poster) VALUES
('Interstellar', 'Un equipo de exploradores viaja a través de un agujero de gusano en el espacio.', 'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg'),
('The Dark Knight', 'Batman se enfrenta al Joker, un criminal caótico que aterroriza Gotham.', 'https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg'),
('Avengers: Endgame', 'Los Vengadores intentan revertir el daño causado por Thanos.', 'https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg'),
('Gladiator', 'Un general romano traicionado busca venganza contra el emperador corrupto.', 'https://image.tmdb.org/t/p/w500/ty8TGRuvJLPUmAR1H1nRIsgwvim.jpg'),
('Forrest Gump', 'Un hombre con un coeficiente intelectual bajo, pero un gran corazón, presencia eventos históricos.', 'https://image.tmdb.org/t/p/w500/saHP97rTPS5eLmrLQEcANmKrsFl.jpg'),
('The Shawshank Redemption', 'Un banquero acusado de asesinato lucha por su libertad en prisión.', 'https://image.tmdb.org/t/p/w500/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg'),
('The Godfather', 'La historia de la familia Corleone y su legado en el crimen organizado.', 'https://image.tmdb.org/t/p/w500/3bhkrj58Vtu7enYsRolD1fZdja1.jpg'),
('Fight Club', 'Un hombre aburrido de su vida se une a un club de lucha clandestino.', 'https://image.tmdb.org/t/p/w500/bptfVGEQuv6vDTIMVCHjJ9Dz8PX.jpg'),
('Deadpool', 'Un mercenario con un sentido del humor retorcido busca venganza.', 'https://image.tmdb.org/t/p/w500/fSRb7vyIP8rQpL0I47P3qUsEKX3.jpg'),
('Coco', 'Un niño viaja a la Tierra de los Muertos en busca de su bisabuelo músico.', 'https://image.tmdb.org/t/p/w500/askg3SMvhqEl4OL52YuvdtY40Yb.jpg'),
('Toy Story', 'Los juguetes de un niño cobran vida y viven aventuras inolvidables.', 'https://image.tmdb.org/t/p/w500/uXDfjJbdP4ijW5hWSBrPrlKpxab.jpg'),
('The Avengers', 'Los héroes más poderosos de la Tierra se unen para enfrentar a Loki.', 'https://image.tmdb.org/t/p/w500/RYMX2wcKCBAr24UyPD7xwmjaTn.jpg'),
('Dune', 'Un joven noble enfrenta su destino en un planeta desértico lleno de peligros.', 'https://image.tmdb.org/t/p/w500/d5NXSklXo0qyIYkgV94XAgMIckC.jpg');
-- Películas de Harry Potter
('Harry Potter y la cámara secreta', 'Harry regresa a Hogwarts y enfrenta un misterio en la Cámara Secreta.', 'https://image.tmdb.org/t/p/w500/sdEOH0992YZ0QSxgXNIGLq1ToUi.jpg'),
('Harry Potter y el prisionero de Azkaban', 'Harry descubre la verdad sobre Sirius Black y su pasado.', 'https://image.tmdb.org/t/p/w500/aWxwnYoe8p2d2fcxOqtvAtJ72Rw.jpg'),
('Harry Potter y el cáliz de fuego', 'Harry participa en el Torneo de los Tres Magos y enfrenta nuevos peligros.', 'https://image.tmdb.org/t/p/w500/fECBtHlr0RB3foNHDiCBXeg9Bv9.jpg'),
('Harry Potter y la Orden del Fénix', 'Harry forma un grupo secreto para enseñar defensa contra las artes oscuras.', 'https://image.tmdb.org/t/p/w500/5aOyriWkPec0zUDxmHFP9qMmBaj.jpg'),
('Harry Potter y el misterio del príncipe', 'Harry descubre más sobre el pasado de Voldemort y busca horrocruxes.', 'https://image.tmdb.org/t/p/w500/z7uo9zmQdQwU5ZJHFpv2Upl30i1.jpg'),

-- Películas de El Señor de los Anillos
('El Señor de los Anillos: La Comunidad del Anillo', 'Un hobbit emprende un peligroso viaje para destruir un anillo maligno.', 'https://image.tmdb.org/t/p/w500/6oom5QYQ2yQTMJIbnvbkBL9cHo6.jpg'),
('El Señor de los Anillos: Las Dos Torres', 'Frodo y Sam continúan su viaje mientras la guerra se intensifica.', 'https://image.tmdb.org/t/p/w500/5VTN0pR8gcqV3EPUHHfMGnJYN9L.jpg'),
('El Señor de los Anillos: El Retorno del Rey', 'La batalla final contra Sauron decidirá el destino de la Tierra Media.', 'https://image.tmdb.org/t/p/w500/rCzpDGLbOoPwLjy3OAm5NUPOTrC.jpg'),

-- Películas de El Hobbit
('El Hobbit: Un viaje inesperado', 'Bilbo Bolsón se une a un grupo de enanos para reclamar su hogar de un dragón.', 'https://image.tmdb.org/t/p/w500/yHA9Fc37VmpUA5UncTxxo3rTGVA.jpg'),
('El Hobbit: La desolación de Smaug', 'Bilbo y los enanos continúan su viaje hacia la Montaña Solitaria.', 'https://image.tmdb.org/t/p/w500/xQYiXsheRCDBA39DOrmaw1aSpbk.jpg'),
('El Hobbit: La batalla de los cinco ejércitos', 'Las fuerzas de la oscuridad y la luz se enfrentan en una batalla épica.', 'https://image.tmdb.org/t/p/w500/8Qsr8pvDL3s1jNZQ4HK1d1Xlvnh.jpg'),



-- Película de Transformers
('Transformers: El último caballero', 'Los humanos están en guerra con los Transformers, y la clave para salvar el futuro yace en los secretos del pasado.', 'https://image.tmdb.org/t/p/w500/6TjllWT3cGrPFyqDXurVZ3L8bBi.jpg'),


-- Inserciones para la tabla inventario_peliculas
INSERT INTO inventario_peliculas (pelicula_id, cantidad_disponible) VALUES
(1, 3),
(2, 2),
(3, 1),
(4, 4),
(5, 5),
(6, 2),
(7, 2),
(8, 2),
(9, 3),
(10, 2),
(11, 4),
(12, 3),
(13, 2),
(14, 1),
(15, 1),
(16, 4),
(17, 4),
(18, 4),
(19, 1),
(20, 3),
(22, 2),
(23, 2),
(25, 2),
(27, 2),
(29, 2),
(31, 3),
(32, 2),
(33, 4),
(34, 1),
(36, 3),
(37, 2),
(39, 4),
(40, 4),
(42, 3),
(43, 3),
(44, 3),
(45, 2),
(46, 5),
(49, 0),
(50, 3),
(51, 2),
(52, 2),
(53, 2),
(54, 2),
(60, 3),
(72, 3),
(73, 2),
(74, 1),
(75, 3),
(76, 2),
(77, 1),
(78, 3);