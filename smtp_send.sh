#!/bin/bash

# --- Configuración de tu correo y servidor ---
# Rellena estos datos con la configuración de tu cuenta de correo de Neubox.
# Puedes obtener estos datos de la respuesta anterior o del panel de Neubox.

# Servidor SMTP (Ej: mail.tudominio.com o smtp.us.appsuite.cloud)
SMTP_SERVER="smtp.gmail.com"

# Puerto SMTP (Ej: 587 para TLS, 465 para SSL)
SMTP_PORT="465"

# Tu dirección de correo completa (Ej: tu-correo@tudominio.com)
SENDER_EMAIL="admin@saetlax.org"

# Tu contraseña de correo
SENDER_PASSWORD="dkxifjaejbgqwfaa"

# Correo del destinatario (puede ser el mismo que el tuyo para una prueba)
RECIPIENT_EMAIL="rtcface@gmail.com"

# Asunto del correo
SUBJECT="Prueba de envío SMTP (Bash Curl)"

# Cuerpo del mensaje
BODY="Este es un correo de prueba enviado automáticamente usando un script Bash con curl."

# --- Configuración de Seguridad (Importante) ---
# Curl usa diferentes esquemas (smtp:// o smtps://) y flags (--ssl, --tls)
# dependiendo de si es SSL directo (465) o STARTTLS (587).

CURL_URL=""
CURL_SECURE_FLAG="" # Variable para flags de seguridad opcionales

if [ "$SMTP_PORT" -eq 465 ]; then
  # Para puerto 465, usualmente es SSL directo (smtps://)
  CURL_URL="smtps://${SMTP_SERVER}:${SMTP_PORT}"
  CURL_SECURE_FLAG="--ssl" # Explicitamente indicamos SSL
  echo "Configurando para SMTPS (SSL directo) en puerto 465."
elif [ "$SMTP_PORT" -eq 587 ]; then
  # Para puerto 587, usualmente es STARTTLS después de conectar (smtp:// + --tls)
  CURL_URL="smtp://${SMTP_SERVER}:${SMTP_PORT}"
  CURL_SECURE_FLAG="--tls" # Explicitamente indicamos STARTTLS
  echo "Configurando para SMTP con STARTTLS en puerto 587."
else
  # Para otros puertos, usaremos SMTP estándar (smtp://)
  CURL_URL="smtp://${SMTP_SERVER}:${SMTP_PORT}"
  echo "Configurando para SMTP estándar en puerto $SMTP_PORT (sin cifrado explícito)."
  echo "ADVERTENCIA: El envío sin cifrado (SSL/TLS) no es seguro para credenciales."
fi

# --- Creación del Archivo del Mensaje ---
# Creamos un archivo temporal con el contenido del correo (cabeceras + cuerpo)
# Esto es necesario porque curl lee el mensaje desde un archivo o entrada estándar.

# Genera un nombre de archivo temporal seguro
MESSAGE_FILE=$(mktemp /tmp/email_test_curl.XXXXXX)

# Asegura que el archivo temporal se borre al salir del script (incluso si hay errores)
trap "rm -f \"$MESSAGE_FILE\"" EXIT

# Escribe las cabeceras y el cuerpo en el archivo temporal
cat <<EOF > "$MESSAGE_FILE"
From: $SENDER_EMAIL
To: $RECIPIENT_EMAIL
Subject: $SUBJECT

$BODY
EOF

echo "Archivo de mensaje temporal creado: $MESSAGE_FILE"

# --- Envío del Correo con curl ---
echo "Intentando enviar correo a través de $CURL_URL con usuario $SENDER_EMAIL..."

# El comando curl para enviar correo
# -v: Muestra el proceso detallado (útil para depurar)
# -u: Usuario y contraseña para autenticación
# --mail-from: Dirección del remitente en el sobre SMTP
# --mail-rcpt: Dirección del destinatario en el sobre SMTP (puede repetirse para múltiples destinatarios)
# -T: Especifica el archivo que contiene el mensaje a enviar
# $CURL_SECURE_FLAG: Incluye el flag de seguridad (--ssl o --tls) si se definió

curl -v \
     --url "$CURL_URL" \
     -u "$SENDER_EMAIL:$SENDER_PASSWORD" \
     --mail-from "$SENDER_EMAIL" \
     --mail-rcpt "$RECIPIENT_EMAIL" \
     -T "$MESSAGE_FILE" \
     $CURL_SECURE_FLAG

# El comando 'trap' se encargará de borrar $MESSAGE_FILE al finalizar.

echo "Fin del script de prueba SMTP."