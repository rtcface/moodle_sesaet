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
sudo chmod -R 777 moodle_db
sudo chmod -R 777 moodle_data
sudo chmod -R 777 moodledata_data
sudo chmod -R 777 moodle_data_backup
sudo chmod -R 777 moodledata_data_backup

# Establecer propietario (ajustar según el usuario que ejecute Docker)
echo "Estableciendo propietario..."
sudo chown -R 1001:1001 moodle_db
sudo chown -R 1001:1001 moodle_data
sudo chown -R 1001:1001 moodledata_data
sudo chown -R 1001:1001 moodle_data_backup
sudo chown -R 1001:1001 moodledata_data_backup

echo "Configuración completada. Ahora puedes ejecutar 'docker-compose up -d'" 