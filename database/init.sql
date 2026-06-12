-- Crear base de datos (ejecutar como superusuario)
CREATE DATABASE usuarios_db;
CREATE USER app_user WITH ENCRYPTED PASSWORD 'app_pass';
GRANT ALL PRIVILEGES ON DATABASE usuarios_db TO app_user;

-- Conectar a la base de datos antes de ejecutar el resto
\c usuarios_db;

GRANT ALL ON SCHEMA public TO app_user;

-- Tabla principal de usuarios
CREATE TABLE usuarios (
    id          BIGSERIAL PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,          -- BCrypt hash
    nombre      VARCHAR(100) NOT NULL,
    email       VARCHAR(150) NOT NULL UNIQUE,
    rol         VARCHAR(20)  NOT NULL DEFAULT 'USER',  -- 'ADMIN' | 'USER'
    activo      BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Datos iniciales (contraseñas hasheadas con BCrypt, factor 10)
-- admin123  → $2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBpwTTyU.NV/G2
-- user123   → $2a$10$EblZqNptyYvcLm/VwDCVAuBjzZOI7khzdyGPBr08PFR1JIv.Z98KW
INSERT INTO usuarios (username, password, nombre, email, rol) VALUES
    ('admin',  '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBpwTTyU.NV/G2', 'Administrador', 'admin@example.com', 'ADMIN'),
    ('user1',  '$2a$10$EblZqNptyYvcLm/VwDCVAuBjzZOI7khzdyGPBr08PFR1JIv.Z98KW', 'Usuario Uno',   'user1@example.com', 'USER');
