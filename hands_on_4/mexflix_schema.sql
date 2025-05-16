-- ========== CREACIÓN DE BASE DE DATOS ==========
CREATE DATABASE streaming_service;
\c streaming_service

-- ========== TABLA USUARIO ==========
CREATE TABLE USUARIO (
    UsuarioID INT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    RFC VARCHAR(13) NOT NULL UNIQUE,
    Direccion VARCHAR(200) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    FechaRegistro DATE NOT NULL
);

-- ========== TABLA MEMBRESIA ==========
CREATE TABLE MEMBRESIA (
    MembresiaID INT PRIMARY KEY,
    UsuarioID INT NOT NULL,
    Tipo VARCHAR(20) NOT NULL CHECK (Tipo IN ('Standard','Extendida','Premium')),
    Costo DECIMAL(10,2) NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    FOREIGN KEY (UsuarioID) REFERENCES USUARIO(UsuarioID)
);

-- ========== TABLA TARJETA ==========
CREATE TABLE TARJETA (
    TarjetaID INT PRIMARY KEY,
    UsuarioID INT NOT NULL,
    Numero VARCHAR(16) NOT NULL,
    Tipo VARCHAR(20) NOT NULL CHECK (Tipo IN ('VISA','MASTERCARD','AMEX')),
    FechaExpiracion DATE NOT NULL,
    FOREIGN KEY (UsuarioID) REFERENCES USUARIO(UsuarioID)
);

-- ========== TABLA CATEGORIA ==========
CREATE TABLE CATEGORIA (
    CategoriaID INT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE
);

-- ========== TABLA PELICULA ==========
CREATE TABLE PELICULA (
    PeliculaID INT PRIMARY KEY,
    CategoriaID INT NOT NULL,
    Titulo VARCHAR(100) NOT NULL,
    Duracion INT NOT NULL,
    FechaEstreno DATE NOT NULL,
    EsEstreno BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (CategoriaID) REFERENCES CATEGORIA(CategoriaID)
);

-- ========== TABLA SERIE ==========
CREATE TABLE SERIE (
    SerieID INT PRIMARY KEY,
    CategoriaID INT NOT NULL,
    Titulo VARCHAR(100) NOT NULL,
    FechaEstreno DATE NOT NULL,
    FOREIGN KEY (CategoriaID) REFERENCES CATEGORIA(CategoriaID)
);

-- ========== TABLA ACTOR ==========
CREATE TABLE ACTOR (
    ActorID INT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL
);

-- ========== TABLA SERIE_ACTOR (relación M:N) ==========
CREATE TABLE SERIE_ACTOR (
    SerieID INT NOT NULL,
    ActorID INT NOT NULL,
    PRIMARY KEY (SerieID, ActorID),
    FOREIGN KEY (SerieID) REFERENCES SERIE(SerieID),
    FOREIGN KEY (ActorID) REFERENCES ACTOR(ActorID)
);

-- ========== TABLA EPISODIO ==========
CREATE TABLE EPISODIO (
    EpisodioID INT PRIMARY KEY,
    SerieID INT NOT NULL,
    Titulo VARCHAR(100) NOT NULL,
    Duracion INT NOT NULL,
    NumeroTemporada INT NOT NULL,
    NumeroEpisodio INT NOT NULL,
    FOREIGN KEY (SerieID) REFERENCES SERIE(SerieID)
);

-- ========== TABLA DISPOSITIVO ==========
CREATE TABLE DISPOSITIVO (
    DispositivoID INT PRIMARY KEY,
    Tipo VARCHAR(20) NOT NULL CHECK (Tipo IN ('smartphone','tablet','laptop','TV'))
);

-- ========== TABLA CONSUMO ==========
CREATE TABLE CONSUMO (
    ConsumoID INT PRIMARY KEY,
    UsuarioID INT NOT NULL,
    PeliculaID INT NULL,
    EpisodioID INT NULL,
    TipoContenido VARCHAR(10) NOT NULL CHECK (TipoContenido IN ('Pelicula','Episodio')),
    FechaHoraInicio TIMESTAMP NOT NULL,
    FechaHoraFin TIMESTAMP NULL,
    DispositivoID INT NOT NULL,
    EsRenta BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (UsuarioID) REFERENCES USUARIO(UsuarioID),
    FOREIGN KEY (PeliculaID) REFERENCES PELICULA(PeliculaID),
    FOREIGN KEY (EpisodioID) REFERENCES EPISODIO(EpisodioID),
    FOREIGN KEY (DispositivoID) REFERENCES DISPOSITIVO(DispositivoID),
    CHECK (
        (TipoContenido = 'Pelicula' AND PeliculaID IS NOT NULL AND EpisodioID IS NULL)
        OR
        (TipoContenido = 'Episodio' AND EpisodioID IS NOT NULL AND PeliculaID IS NULL)
    )
);

CREATE INDEX idx_consumo_usuarioid ON CONSUMO(UsuarioID);

-- ========== TABLA SESION ==========
CREATE TABLE SESION (
    SesionID INT PRIMARY KEY,
    UsuarioID INT NOT NULL,
    DispositivoID INT NOT NULL,
    FechaHoraInicio TIMESTAMP NOT NULL,
    FechaHoraFin TIMESTAMP NULL,
    FOREIGN KEY (UsuarioID) REFERENCES USUARIO(UsuarioID),
    FOREIGN KEY (DispositivoID) REFERENCES DISPOSITIVO(DispositivoID)
);

-- ========== TABLA FACTURA ==========
CREATE TABLE FACTURA (
    FacturaID INT PRIMARY KEY,
    UsuarioID INT NOT NULL,
    Fecha DATE NOT NULL,
    MontoCuotaMensual DECIMAL(10,2) NOT NULL,
    MontoRentasAdicionales DECIMAL(10,2) NOT NULL DEFAULT 0,
    MontoTotal DECIMAL(10,2) NOT NULL,
    Estado VARCHAR(20) NOT NULL CHECK (Estado IN ('Al corriente','Deudor')),
    FOREIGN KEY (UsuarioID) REFERENCES USUARIO(UsuarioID)
);

CREATE INDEX idx_factura_usuarioid ON FACTURA(UsuarioID);
CREATE INDEX idx_membresia_usuarioid ON MEMBRESIA(UsuarioID);
CREATE INDEX idx_tarjeta_usuarioid ON TARJETA(UsuarioID);
CREATE INDEX idx_sesion_usuarioid ON SESION(UsuarioID);
