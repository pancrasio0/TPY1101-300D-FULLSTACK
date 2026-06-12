# TPY1101-300D-FULLSTACK

Aplicación web Full Stack para gestión de usuarios con autenticación JWT.

## Stack Tecnológico

- **Frontend:** React 18 + Vite 5 + React Router 6 + Axios
- **Backend:** Spring Boot 3.2 + Spring Security + Spring Data JPA
- **Base de Datos:** PostgreSQL
- **Autenticación:** JWT (JSON Web Tokens)

---

## Estructura del Proyecto

```
TPY1101-300D-FULLSTACK/
├── frontend/          # React + Vite (puerto 5173)
│   ├── src/
│   │   ├── api/       # Axios config y servicios
│   │   ├── context/   # AuthContext (JWT)
│   │   ├── pages/     # LoginPage, UsuariosPage
│   │   ├── components/# ProtectedRoute, UsuarioModal, UsuarioTable
│   │   └── styles/    # Módulos CSS
│   └── package.json
├── backend/           # Spring Boot (puerto 8080)
│   ├── src/main/java/com/app/usuarios/
│   │   ├── config/    # SecurityConfig, JwtFilter
│   │   ├── controller/# AuthController, UsuarioController
│   │   ├── dto/       # LoginRequest, LoginResponse, UsuarioDTO
│   │   ├── model/     # Usuario (JPA entity)
│   │   ├── repository/# UsuarioRepository
│   │   └── service/   # AuthService, UsuarioService, JwtService
│   ├── src/main/resources/
│   │   └── application.properties
│   └── pom.xml
├── database/
│   └── init.sql       # Script de creación de DB y tablas
└── README.md
```

---

## Requisitos Previos

- **Java 17+** (usado: Java 21)
- **Node.js 18+** (usado: Node 25)
- **npm**
- **PostgreSQL 12+** corriendo en `localhost:5432`

---

## Instalación y Ejecución

### 1. Base de Datos

Ejecutar como superusuario de PostgreSQL:

```bash
psql -U postgres -f database/init.sql
```

Esto crea:
- Base de datos `usuarios_db`
- Usuario `app_user` con password `app_pass`
- Tabla `usuarios`
- Datos de prueba (admin + user1)

### 2. Backend (Spring Boot)

```bash
cd backend
mvn clean package          # compilar (opcional, ya viene precompilado)
java -jar target/usuarios-1.0.0.jar
```

El backend inicia en **http://localhost:8080**.

### 3. Frontend (React + Vite)

```bash
cd frontend
npm install
npm run dev
```

El frontend inicia en **http://localhost:5173**.

---

## Puertos Utilizados

| Componente | Puerto |
|---|---|
| Frontend (Vite) | 5173 |
| Backend (Spring Boot) | 8080 |
| Base de Datos (PostgreSQL) | 5432 |

---

## API Endpoints

| Método | Endpoint | Auth | Descripción |
|---|---|---|---|
| POST | `/api/auth/login` | No | Iniciar sesión |
| GET | `/api/usuarios` | JWT | Listar usuarios |
| GET | `/api/usuarios/{id}` | JWT | Obtener usuario por ID |
| POST | `/api/usuarios` | JWT | Crear usuario |
| PUT | `/api/usuarios/{id}` | JWT | Actualizar usuario |
| DELETE | `/api/usuarios/{id}` | JWT | Eliminar usuario |

---

## Credenciales de Prueba

| Usuario | Contraseña | Rol |
|---|---|---|
| `admin` | `admin123` | ADMIN |
| `user1` | `user123` | USER |

El rol ADMIN puede crear, editar y eliminar usuarios. El rol USER tiene acceso de solo lectura.

---

## Dependencias

### Frontend

| Dependencia | Versión |
|---|---|
| react | ^18.2.0 |
| react-dom | ^18.2.0 |
| react-router-dom | ^6.22.0 |
| axios | ^1.6.0 |
| vite | ^5.1.0 |

### Backend

| Dependencia | Versión |
|---|---|
| Spring Boot | 3.2.5 |
| spring-boot-starter-web | - |
| spring-boot-starter-security | - |
| spring-boot-starter-data-jpa | - |
| postgresql | runtime |
| lombok | optional |
| jjwt (api, impl, jackson) | 0.12.3 |

---

## Configuración de Base de Datos

Archivo: `backend/src/main/resources/application.properties`

```properties
server.port=8080
spring.datasource.url=jdbc:postgresql://localhost:5432/usuarios_db
spring.datasource.username=app_user
spring.datasource.password=app_pass
spring.jpa.hibernate.ddl-auto=update
app.jwt.secret=miClaveSecretaMuyLargaParaHMAC256BitsMinimo1234567890
app.jwt.expiration=86400000
```

---

## Integrantes

- Benjamín Pérez
- Claudio Jorquera
- Simón Astudillo
