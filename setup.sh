#!/bin/bash

# Crear directorios necesarios
echo "Creando directorios..."
mkdir -p moodle_db
mkdir -p moodle_data
mkdir -p moodledata_data
mkdir -p moodle_data_backup
mkdir -p moodledata_data_backup

# Establecer permisos
echo "Estableciendo permisos..."
chmod -R 777 moodle_db
chmod -R 777 moodle_data
chmod -R 777 moodledata_data
chmod -R 777 moodle_data_backup
chmod -R 777 moodledata_data_backup

# Establecer propietario (ajustar según el usuario que ejecute Docker)
echo "Estableciendo propietario..."
chown -R 1001:1001 moodle_db
chown -R 1001:1001 moodle_data
chown -R 1001:1001 moodledata_data
chown -R 1001:1001 moodle_data_backup
chown -R 1001:1001 moodledata_data_backup

echo "Configuración completada. Ahora puedes ejecutar 'docker-compose up -d'" 