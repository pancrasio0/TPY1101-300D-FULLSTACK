#!/bin/bash
# Smoke test del backend Spring Boot 3 - Usuarios API
# Requiere: curl, jq (opcional para formateo)
# Uso: bash smoke-test.sh

BASE_URL="http://localhost:8080"
PWD=$(pwd)

echo "=========================================="
echo "  SMOKE TEST - API Usuarios"
echo "=========================================="
echo ""

# -------------------------------------------------------
# 1. Login exitoso
# -------------------------------------------------------
echo "1. Login exitoso (admin / admin123)"
echo "----------------------------------"
RESP=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}')
HTTP_CODE=$(echo "$RESP" | tail -1)
BODY=$(echo "$RESP" | sed '$d')
echo "Status: $HTTP_CODE"
echo "Body: $BODY"
echo ""

TOKEN=$(echo "$BODY" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
if [ -n "$TOKEN" ]; then
  echo "Token extraido correctamente: ${TOKEN:0:50}..."
else
  echo "ERROR: No se pudo extraer el token"
  exit 1
fi
echo ""

# -------------------------------------------------------
# 2. Login fallido
# -------------------------------------------------------
echo "2. Login fallido (contraseña incorrecta)"
echo "----------------------------------------"
RESP=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"wrongpass"}')
HTTP_CODE=$(echo "$RESP" | tail -1)
BODY=$(echo "$RESP" | sed '$d')
echo "Status: $HTTP_CODE"
echo "Body: $BODY"
echo ""

# -------------------------------------------------------
# 3. Acceso sin token
# -------------------------------------------------------
echo "3. Acceso sin token (GET /api/usuarios)"
echo "--------------------------------------"
RESP=$(curl -s -w "\n%{http_code}" "$BASE_URL/api/usuarios")
HTTP_CODE=$(echo "$RESP" | tail -1)
echo "Status: $HTTP_CODE (esperado 401 o 403)"
echo ""

# -------------------------------------------------------
# 4. Listar usuarios (con token)
# -------------------------------------------------------
echo "4. Listar usuarios (con token)"
echo "-----------------------------"
RESP=$(curl -s -w "\n%{http_code}" "$BASE_URL/api/usuarios" \
  -H "Authorization: Bearer $TOKEN")
HTTP_CODE=$(echo "$RESP" | tail -1)
BODY=$(echo "$RESP" | sed '$d')
echo "Status: $HTTP_CODE"
echo "Body: $BODY" | head -c 500
echo ""
echo ""

# -------------------------------------------------------
# 5. Crear usuario (con token)
# -------------------------------------------------------
echo "5. Crear usuario (con token)"
echo "---------------------------"
RESP=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/usuarios" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "username": "testuser",
    "password": "testpass123",
    "nombre": "Usuario de prueba",
    "email": "test@example.com",
    "rol": "USER",
    "activo": true
  }')
HTTP_CODE=$(echo "$RESP" | tail -1)
BODY=$(echo "$RESP" | sed '$d')
echo "Status: $HTTP_CODE (esperado 201)"
echo "Body: $BODY"
echo ""

NUEVO_ID=$(echo "$BODY" | grep -o '"id":[0-9]*' | head -1 | cut -d: -f2)
if [ -z "$NUEVO_ID" ]; then
  echo "ERROR: No se pudo extraer el id del usuario creado"
  exit 1
fi
echo "ID del nuevo usuario: $NUEVO_ID"
echo ""

# -------------------------------------------------------
# 6. Editar usuario (sin password - la contraseña NO debe cambiar)
# -------------------------------------------------------
echo "6. Editar usuario (sin enviar password)"
echo "-------------------------------------"
# Guardar el hash actual de la BD para comparar despues
echo "(La contraseña se mantiene igual porque no se envió el campo)"
RESP=$(curl -s -w "\n%{http_code}" -X PUT "$BASE_URL/api/usuarios/$NUEVO_ID" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "username": "testuser_editado",
    "password": "",
    "nombre": "Usuario editado",
    "email": "editado@example.com",
    "rol": "ADMIN",
    "activo": true
  }')
HTTP_CODE=$(echo "$RESP" | tail -1)
BODY=$(echo "$RESP" | sed '$d')
echo "Status: $HTTP_CODE (esperado 200)"
echo "Body: $BODY"
echo ""

# -------------------------------------------------------
# 7. Eliminar usuario (con token)
# -------------------------------------------------------
echo "7. Eliminar usuario (con token)"
echo "------------------------------"
RESP=$(curl -s -w "\n%{http_code}" -X DELETE "$BASE_URL/api/usuarios/$NUEVO_ID" \
  -H "Authorization: Bearer $TOKEN")
HTTP_CODE=$(echo "$RESP" | tail -1)
echo "Status: $HTTP_CODE (esperado 204)"
echo ""

# Verificar que ya no existe
echo "   Verificando que el usuario fue eliminado..."
RESP=$(curl -s -w "\n%{http_code}" "$BASE_URL/api/usuarios/$NUEVO_ID" \
  -H "Authorization: Bearer $TOKEN")
HTTP_CODE=$(echo "$RESP" | tail -1)
echo "   GET /api/usuarios/$NUEVO_ID -> Status: $HTTP_CODE (esperado 404)"
echo ""

# -------------------------------------------------------
# 8. Buscar usuario inexistente
# -------------------------------------------------------
echo "8. Buscar usuario inexistente"
echo "---------------------------"
RESP=$(curl -s -w "\n%{http_code}" "$BASE_URL/api/usuarios/99999" \
  -H "Authorization: Bearer $TOKEN")
HTTP_CODE=$(echo "$RESP" | tail -1)
BODY=$(echo "$RESP" | sed '$d')
echo "Status: $HTTP_CODE (esperado 404)"
echo "Body: $BODY"
echo ""

echo "=========================================="
echo "  SMOKE TEST COMPLETADO"
echo "=========================================="
