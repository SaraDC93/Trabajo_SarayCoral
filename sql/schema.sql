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
('Inception', 'Un ladrón que roba secretos corporativos a través del uso de la tecnología de sueños.', 'https://image.tmdb.org/t/p/w500/8hP9D40g9KiP6t2uoiqhFeBiLGA.jpg'),
('Interstellar', 'Un equipo de exploradores viaja a través de un agujero de gusano en el espacio.', 'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg'),
('The Dark Knight', 'Batman se enfrenta al Joker, un criminal caótico que aterroriza Gotham.', 'https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg'),
('The Matrix', 'Un hacker descubre la verdad sobre su realidad y lucha contra máquinas que controlan el mundo.', 'https://image.tmdb.org/t/p/w500/a3ni9i6LbYORZQe7p5FGnJKRaGs.jpg'),
('Avengers: Endgame', 'Los Vengadores intentan revertir el daño causado por Thanos.', 'https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg'),
('Titanic', 'Una historia de amor entre Jack y Rose en el trágico viaje del Titanic.', 'https://image.tmdb.org/t/p/w500/kHXEpyfl6zqn8a6YuozZUujufXf.jpg'),
('Gladiator', 'Un general romano traicionado busca venganza contra el emperador corrupto.', 'https://image.tmdb.org/t/p/w500/ty8TGRuvJLPUmAR1H1nRIsgwvim.jpg'),
('Jurassic Park', 'Un parque temático con dinosaurios clonados se convierte en una pesadilla.', 'https://image.tmdb.org/t/p/w500/1alMsxv2ahM5LjNHlNUO8zCnH2p.jpg'),
('Forrest Gump', 'Un hombre con un coeficiente intelectual bajo, pero un gran corazón, presencia eventos históricos.', 'https://image.tmdb.org/t/p/w500/saHP97rTPS5eLmrLQEcANmKrsFl.jpg'),
('Pulp Fiction', 'Historias entrelazadas de crimen y redención en Los Ángeles.', 'https://image.tmdb.org/t/p/w500/tN5ifQQl5MqZbSjbJmVXQKMFNnN.jpg'),
('The Shawshank Redemption', 'Un banquero acusado de asesinato lucha por su libertad en prisión.', 'https://image.tmdb.org/t/p/w500/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg'),
('The Godfather', 'La historia de la familia Corleone y su legado en el crimen organizado.', 'https://image.tmdb.org/t/p/w500/3bhkrj58Vtu7enYsRolD1fZdja1.jpg'),
('Fight Club', 'Un hombre aburrido de su vida se une a un club de lucha clandestino.', 'https://image.tmdb.org/t/p/w500/bptfVGEQuv6vDTIMVCHjJ9Dz8PX.jpg'),
('Deadpool', 'Un mercenario con un sentido del humor retorcido busca venganza.', 'https://image.tmdb.org/t/p/w500/fSRb7vyIP8rQpL0I47P3qUsEKX3.jpg'),
('The Lion King', 'Un joven león aprende sobre el ciclo de la vida mientras se convierte en rey.', 'https://image.tmdb.org/t/p/w500/2KiloSgY1f1s0Z5aCQ5VmucMTwV.jpg'),
('Coco', 'Un niño viaja a la Tierra de los Muertos en busca de su bisabuelo músico.', 'https://image.tmdb.org/t/p/w500/askg3SMvhqEl4OL52YuvdtY40Yb.jpg'),
('Toy Story', 'Los juguetes de un niño cobran vida y viven aventuras inolvidables.', 'https://image.tmdb.org/t/p/w500/uXDfjJbdP4ijW5hWSBrPrlKpxab.jpg'),
('Spider-Man: No Way Home', 'Peter Parker lidia con el multiverso mientras enfrenta viejos enemigos.', 'https://image.tmdb.org/t/p/w500/5fVayFfABaEMTzCMqOfjKK0xfNI.jpg'),
('The Avengers', 'Los héroes más poderosos de la Tierra se unen para enfrentar a Loki.', 'https://image.tmdb.org/t/p/w500/RYMX2wcKCBAr24UyPD7xwmjaTn.jpg'),
('Dune', 'Un joven noble enfrenta su destino en un planeta desértico lleno de peligros.', 'https://image.tmdb.org/t/p/w500/d5NXSklXo0qyIYkgV94XAgMIckC.jpg');
-- Películas de Harry Potter
('Harry Potter y la piedra filosofal', 'Un niño descubre que es un mago y asiste a Hogwarts.', 'https://image.tmdb.org/t/p/w500/4SGRs3jpshAIxiwBcsyZxi3qdtU.jpg'),
('Harry Potter y la cámara secreta', 'Harry regresa a Hogwarts y enfrenta un misterio en la Cámara Secreta.', 'https://image.tmdb.org/t/p/w500/sdEOH0992YZ0QSxgXNIGLq1ToUi.jpg'),
('Harry Potter y el prisionero de Azkaban', 'Harry descubre la verdad sobre Sirius Black y su pasado.', 'https://image.tmdb.org/t/p/w500/aWxwnYoe8p2d2fcxOqtvAtJ72Rw.jpg'),
('Harry Potter y el cáliz de fuego', 'Harry participa en el Torneo de los Tres Magos y enfrenta nuevos peligros.', 'https://image.tmdb.org/t/p/w500/fECBtHlr0RB3foNHDiCBXeg9Bv9.jpg'),
('Harry Potter y la Orden del Fénix', 'Harry forma un grupo secreto para enseñar defensa contra las artes oscuras.', 'https://image.tmdb.org/t/p/w500/5aOyriWkPec0zUDxmHFP9qMmBaj.jpg'),
('Harry Potter y el misterio del príncipe', 'Harry descubre más sobre el pasado de Voldemort y busca horrocruxes.', 'https://image.tmdb.org/t/p/w500/z7uo9zmQdQwU5ZJHFpv2Upl30i1.jpg'),
('Harry Potter y las Reliquias de la Muerte - Parte 1', 'Harry, Ron y Hermione buscan los horrocruxes para derrotar a Voldemort.', 'https://image.tmdb.org/t/p/w500/maP4MTfPCeVD2FZbKTLUgriOW4R.jpg'),
('Harry Potter y las Reliquias de la Muerte - Parte 2', 'La batalla final entre Harry y Voldemort en Hogwarts.', 'https://image.tmdb.org/t/p/w500/fTplI1NCSuEDP4ITLcTps739fcC.jpg'),

-- Películas de El Señor de los Anillos
('El Señor de los Anillos: La Comunidad del Anillo', 'Un hobbit emprende un peligroso viaje para destruir un anillo maligno.', 'https://image.tmdb.org/t/p/w500/6oom5QYQ2yQTMJIbnvbkBL9cHo6.jpg'),
('El Señor de los Anillos: Las Dos Torres', 'Frodo y Sam continúan su viaje mientras la guerra se intensifica.', 'https://image.tmdb.org/t/p/w500/5VTN0pR8gcqV3EPUHHfMGnJYN9L.jpg'),
('El Señor de los Anillos: El Retorno del Rey', 'La batalla final contra Sauron decidirá el destino de la Tierra Media.', 'https://image.tmdb.org/t/p/w500/rCzpDGLbOoPwLjy3OAm5NUPOTrC.jpg'),

-- Películas de El Hobbit
('El Hobbit: Un viaje inesperado', 'Bilbo Bolsón se une a un grupo de enanos para reclamar su hogar de un dragón.', 'https://image.tmdb.org/t/p/w500/yHA9Fc37VmpUA5UncTxxo3rTGVA.jpg'),
('El Hobbit: La desolación de Smaug', 'Bilbo y los enanos continúan su viaje hacia la Montaña Solitaria.', 'https://image.tmdb.org/t/p/w500/xQYiXsheRCDBA39DOrmaw1aSpbk.jpg'),
('El Hobbit: La batalla de los cinco ejércitos', 'Las fuerzas de la oscuridad y la luz se enfrentan en una batalla épica.', 'https://image.tmdb.org/t/p/w500/8Qsr8pvDL3s1jNZQ4HK1d1Xlvnh.jpg'),

-- Dune Parte 2
('Dune: Parte Dos', 'Paul Atreides une fuerzas con los Fremen para vengar a su familia.', 'https://image.tmdb.org/t/p/w500/kxdYkH2tuTjN1o8qa9oKcnEFfc0.jpg'),

-- Películas de Transformers
('Transformers', 'Un adolescente se ve envuelto en una guerra entre robots alienígenas.', 'https://image.tmdb.org/t/p/w500/2xS0A3H9O6Y45eiNBry9JPf2b1y.jpg'),
('Transformers: La venganza de los caídos', 'Los Autobots enfrentan una nueva amenaza de los Decepticons.', 'https://image.tmdb.org/t/p/w500/2WQp1cM0ZSfYcAHsY6YRwYtUzCk.jpg'),
('Transformers: El lado oscuro de la luna', 'Los Autobots descubren una nave Cybertroniana oculta en la Luna.', 'https://image.tmdb.org/t/p/w500/7ZqJYV02yehWrQN5xgXc2GzQsmx.jpg'),
('Transformers: La era de la extinción', 'Un mecánico y su hija se ven envueltos en la guerra entre Autobots y Decepticons.', 'https://image.tmdb.org/t/p/w500/2WfaSKJrB9zXzFHnZeI0rHr5y1.jpg'),
('Transformers: El último caballero', 'Los humanos están en guerra con los Transformers, y la clave para salvar el futuro yace en los secretos del pasado.', 'https://image.tmdb.org/t/p/w500/6TjllWT3cGrPFyqDXurVZ3L8bBi.jpg'),
('Transformers: El despertar de las bestias', 'Los Autobots y los Maximals unen fuerzas para enfrentar una nueva amenaza.', 'https://image.tmdb.org/t/p/w500/2gGspmX6gGUVU7qJ1JQFELW0NpM.jpg'),

-- Películas extra de 2024
('Deadpool 3', 'Deadpool regresa con nuevas aventuras y un crossover inesperado.', 'https://image.tmdb.org/t/p/w500/deadpool3_poster.jpg'),
('Godzilla x Kong: The New Empire', 'Godzilla y Kong se enfrentan a una nueva amenaza colosal.', 'https://image.tmdb.org/t/p/w500/godzillaxkong_poster.jpg'),
('Joker: Folie à Deux', 'La secuela del Joker con Joaquin Phoenix explorará su relación con Harley Quinn.', 'https://image.tmdb.org/t/p/w500/joker2_poster.jpg'),
('Beetlejuice 2', 'Beetlejuice regresa para más travesuras en el mundo de los vivos.', 'https://image.tmdb.org/t/p/w500/beetlejuice2_poster.jpg'),
('Spider-Man: Beyond the Spider-Verse', 'Miles Morales continúa su viaje por el multiverso.', 'https://image.tmdb.org/t/p/w500/spiderman_beyond_poster.jpg'),
('Avatar 3', 'La continuación de la saga de Pandora con nuevas criaturas y conflictos.', 'https://image.tmdb.org/t/p/w500/avatar3_poster.jpg'),
('The Batman 2', 'La secuela de The Batman con Robert Pattinson.', 'https://image.tmdb.org/t/p/w500/thebatman2_poster.jpg'),
('Inside Out 2', 'Riley ahora es una adolescente con emociones aún más complejas.', 'https://image.tmdb.org/t/p/w500/insideout2_poster.jpg'),
('Mission: Impossible – Dead Reckoning Part Two', 'Ethan Hunt regresa con más acción y espionaje.', 'https://image.tmdb.org/t/p/w500/missionimpossible_poster.jpg'),
('The Flash 2', 'Flash explora nuevas líneas temporales tras los eventos de la primera película.', 'https://image.tmdb.org/t/p/w500/flash2_poster.jpg');
