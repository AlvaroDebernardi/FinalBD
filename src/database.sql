CREATE DATABASE IF NOT EXISTS proyectoBD;
use proyectoBD;

CREATE TABLE IF NOT EXISTS Cine (
    NomCine VARCHAR(100) PRIMARY KEY,
    Direccion VARCHAR(100),
    Tel VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS Sala (
    IDSala INT AUTO_INCREMENT NOT NULL,
    NomCine VARCHAR(100),
    CantButacas INT,
    PRIMARY KEY (IDSala, NomCine),
    FOREIGN KEY (NomCine) REFERENCES Cine(NomCine)
);

CREATE TABLE IF NOT EXISTS Promocion (
    IDprom INT AUTO_INCREMENT PRIMARY KEY,
    Descr VARCHAR(300),
    Descuento DECIMAL(5,2)
);

CREATE TABLE IF NOT EXISTS Pelicula (
    IDpel INT AUTO_INCREMENT PRIMARY KEY,
    añoProd YEAR,
    IdiomaOrig VARCHAR(50),
    TitDistr VARCHAR(50),
    TitOrig VARCHAR(50),
    TitEspañol VARCHAR(50),
    Resumen VARCHAR(300),
    DuracionHora INT,
    DuracionMinutos INT,
    SitioWeb VARCHAR(100),
    Genero VARCHAR(50),
    EstrenoBsAs DATE,
    Calificacion ENUM('ATP', '+13', '+16', '+18')
);

CREATE TABLE IF NOT EXISTS Funcion (
    Codigo INT AUTO_INCREMENT PRIMARY KEY,
    Fecha DATE,
    HoraComie TIME,
    NomCine VARCHAR(100),
    IDSala INT,
    IDpel INT,
    FOREIGN KEY (NomCine) REFERENCES Cine(NomCine),
    FOREIGN KEY (IDSala, NomCine) REFERENCES Sala(IDSala, NomCine),
    FOREIGN KEY (IDpel) REFERENCES Pelicula(IDpel)
);

CREATE TABLE IF NOT EXISTS Opinion (
    IDopin INT AUTO_INCREMENT PRIMARY KEY,
    Comentario VARCHAR(300),
    edadPers INT,
    Calificacion ENUM('OBRA MAESTRA', 'MUY BUENA', 'BUENA', 'REGULAR', 'MALA'),
    Fecha DATE,
    NomPers VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Persona (
    NomPers VARCHAR(100) PRIMARY KEY,
    Nacionalidad VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Actor (
    NomPers VARCHAR(100) PRIMARY KEY,
    CantAct INT,
    FOREIGN KEY (NomPers) REFERENCES Persona(NomPers)
);

CREATE TABLE IF NOT EXISTS Director (
    NomPers VARCHAR(100) PRIMARY KEY,
    CantDir INT,
    FOREIGN KEY (NomPers) REFERENCES Persona(NomPers)
);

CREATE TABLE IF NOT EXISTS Actua (
    IDpel INT,
    NomPers VARCHAR(100),
    PRIMARY KEY (IDpel, NomPers),
    FOREIGN KEY (IDpel) REFERENCES Pelicula(IDpel),
    FOREIGN KEY (NomPers) REFERENCES Actor(NomPers)
);

CREATE TABLE IF NOT EXISTS Dirige (
    IDpel INT,
    NomPers VARCHAR(100),
    PRIMARY KEY (IDpel, NomPers),
    FOREIGN KEY (IDpel) REFERENCES Pelicula(IDpel),
    FOREIGN KEY (NomPers) REFERENCES Director(NomPers)
);

CREATE TABLE IF NOT EXISTS Opinan (
    IDopin INT,
    IDpel INT,
    PRIMARY KEY (IDopin, IDpel),
    FOREIGN KEY (IDopin) REFERENCES Opinion(IDopin),
    FOREIGN KEY (IDpel) REFERENCES Pelicula(IDpel)
);

CREATE TABLE IF NOT EXISTS Dispone (
    Codigo INT,
    IDprom INT,
    PRIMARY KEY (Codigo, IDprom),
    FOREIGN KEY (Codigo) REFERENCES Funcion(Codigo),
    FOREIGN KEY (IDprom) REFERENCES Promocion(IDprom)
);

CREATE TABLE IF NOT EXISTS PaisProd (
    IDpel INT,
    Pais VARCHAR(100),
    PRIMARY KEY (IDpel, Pais),
    FOREIGN KEY (IDpel) REFERENCES Pelicula(IDpel)
);

CREATE TABLE IF NOT EXISTS Posee (
    NomCine VARCHAR(100),
    IDprom INT,
    PRIMARY KEY (NomCine, IDprom),
    FOREIGN KEY (NomCine) REFERENCES Cine(NomCine),
    FOREIGN KEY (IDprom) REFERENCES Promocion(IDprom)
);

CREATE TABLE IF NOT EXISTS AuditoriaEstreno (
    IDAudit INT AUTO_INCREMENT PRIMARY KEY,
    IDpel INT,
    FechaAnterior DATE,
    FechaNueva DATE,
    FechaCambio DATE,
    FOREIGN KEY (IDpel) REFERENCES Pelicula(IDpel)
);


DELIMITER $$

CREATE TRIGGER insertPelicula
BEFORE INSERT ON Pelicula
FOR EACH ROW
BEGIN
    SET NEW.TitOrig = UPPER(NEW.TitOrig);
END;
$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER updateEstreno
AFTER UPDATE ON Pelicula
FOR EACH ROW
BEGIN
    IF NEW.EstrenoBsAs <> OLD.EstrenoBsAs THEN
        INSERT INTO AuditoriaEstreno (IDpel, FechaAnterior, FechaNueva)
        VALUES (OLD.IDpel, OLD.EstrenoBsAs, NEW.EstrenoBsAs, NOW());
    END IF;
END;
$$

DELIMITER ;


-- Cine
INSERT INTO Cine (NomCine, Direccion, Tel) VALUES
  ('Cine Atlas', 'Av. Corrientes 1234', '2148-9179'),
  ('Cine Hoyts', 'Abasto Shopping', '9773-1770'),
  ('Cine Gaumont', 'Av. Rivadavia 1600', '1322-7359'),
  ('Cinemark Palermo', 'Av. Santa Fe 3456', '9788-3617'),
  ('Cine Multiplex', 'Caballito Shopping', '2635-5174');

-- Sala
INSERT INTO Sala (IDSala, NomCine, CantButacas) VALUES
  (1, 'Cine Atlas', 120),
  (2, 'Cine Atlas', 80),
  (1, 'Cine Hoyts', 200),
  (1, 'Cine Gaumont', 100),
  (1, 'Cinemark Palermo', 150);

-- Pelicula
INSERT INTO Pelicula ( añoProd, IdiomaOrig, TitDistr, TitOrig, TitEspañol, Resumen, DuracionHora, DuracionMinutos, SitioWeb, Genero, EstrenoBsAs, Calificacion) VALUES
    (2021, 'Español', 'EL SECRETO', 'EL SECRETO', 'EL SECRETO', 'Un thriller psicológico sobre la verdad y la mentira.', 2, 0, 'http://elsecreto.com', 'Drama', '2021-05-15', '+13'),
    (2023, 'Inglés', 'FAST RUN', 'FAST RUN', 'FUGA RÁPIDA', 'Película de acción trepidante con persecuciones urbanas.', 1, 45, 'http://fastrun.com', 'Acción', '2023-07-22', '+16'),
    (2022, 'Francés', 'L’AMOUR', 'L’AMOUR', 'EL AMOR', 'Historia romántica en París entre dos desconocidos.', 2, 10, 'http://lamour.com', 'Romance', '2022-02-14', 'ATP'),
    (2020, 'Coreano', 'PARASITE', 'GISAENGCHUNG', 'PARÁSITO', 'Un drama social que explora las diferencias de clase.', 2, 15, 'http://parasite.com', 'Drama', '2020-01-30', '+16'),
    (2019, 'Japonés', 'YOUR NAME', 'KIMI NO NA WA', 'TU NOMBRE', 'Anime romántico con elementos sobrenaturales.', 1, 50, 'http://yourname.com', 'Animación', '2019-08-10', 'ATP');

 -- Funcion
 INSERT INTO Funcion(Fecha, HoraComie, NomCine, IDSala, IDpel) VALUES
    ('2025-08-05', '20:30:00', 'Cine Atlas', 1, 1),
    ('2025-08-05', '18:00:00', 'Cine Atlas', 2, 2),
    ('2025-08-06', '22:15:00', 'Cine Hoyts', 1, 3),
    ('2025-08-06', '16:45:00', 'Cine Gaumont', 1, 4),
    ('2025-08-07', '19:00:00', 'Cinemark Palermo', 1, 5);


-- Promocion
INSERT INTO Promocion (IDprom, Descr, Descuento) VALUES
  (1, '2x1 en lunes', 50.00),
  (2, 'Descuento estudiantes', 30.00),
  (3, 'Promo jubilados', 40.00),
  (4, 'Semana del cine', 60.00),
  (5, 'Descuento con Club La Nación', 35.00);

-- Persona
INSERT INTO Persona (NomPers, Nacionalidad) VALUES
  ('Juan Pérez', 'Argentina'),
  ('Lucía Gómez', 'España'),
  ('Akira Tanaka', 'Japón'),
  ('Marie Dubois', 'Francia'),
  ('John Smith', 'EE.UU.');

-- Actor
INSERT INTO Actor (NomPers, CantAct) VALUES
  ('Juan Pérez', 1),
  ('Lucía Gómez', 1),
  ('Akira Tanaka', 1),
  ('Marie Dubois', 0),
  ('John Smith', 0);

-- Director
INSERT INTO Director (NomPers, CantDir) VALUES
  ('John Smith', 1),
  ('Marie Dubois', 1),
  ('Akira Tanaka', 1);

-- Actua
INSERT INTO Actua (IDpel, NomPers) VALUES
  (1, 'Juan Pérez'),
  (2, 'Lucía Gómez'),
  (3, 'Akira Tanaka');

-- Dirige
INSERT INTO Dirige (IDpel, NomPers) VALUES
  (1, 'John Smith'),
  (2, 'Marie Dubois'),
  (3, 'Akira Tanaka');

-- Opinion
INSERT INTO Opinion (IDopin, Comentario, edadPers, Calificacion, Fecha, NomPers) VALUES
  (1, 'Excelente narrativa y dirección', 35, 'OBRA MAESTRA', '2025-08-01', 'Juan Pérez'),
  (2, 'Muy entretenida y bien actuada', 28, 'MUY BUENA', '2025-08-02', 'Lucía Gómez'),
  (3, 'Regular, esperaba más', 42, 'REGULAR', '2025-08-03', 'Marie Dubois');

-- Opinan
INSERT INTO Opinan (IDopin, IDpel) VALUES
  (1, 1),
  (2, 2),
  (3, 3);

-- Dispone
INSERT INTO Dispone (Codigo, IDprom) VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (2, 4);

-- Posee
INSERT INTO Posee (NomCine, IDprom) VALUES
  ('Cine Atlas', 1),
  ('Cine Hoyts', 2),
  ('Cine Gaumont', 3);

-- PaisProd
INSERT INTO PaisProd (IDpel, Pais) VALUES
  (1, 'Argentina'),
  (1, 'España'),
  (1, 'Uruguay'),
  (2, 'EE.UU.'),
  (3, 'Corea del Sur'),
  (5, 'Japon'),
  (5, 'España');
