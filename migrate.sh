#!/bin/bash

# Verificar si existen los directorios de origen
if [ ! -d "moodle_data_old" ] || [ ! -d "moodledata_data_old" ]; then
    echo "Error: No se encontraron los directorios de origen (moodle_data_old o moodledata_data_old)"
    echo "Por favor, renombra tus directorios antiguos a moodle_data_old y moodledata_data_old"
    exit 1
fi

# Detener los contenedores si están corriendo
echo "Deteniendo contenedores..."
docker-compose down

# Crear directorios de respaldo
echo "Creando respaldos de los directorios actuales..."
timestamp=$(date +%Y%m%d_%H%M%S)
mkdir -p backup_${timestamp}

# Preguntar por el ID del curso
read -p "Ingresa el ID del curso que deseas migrar: " course_id

# Verificar si el curso existe en el sistema antiguo
if [ ! -d "moodle_data_old/course/${course_id}" ]; then
    echo "Error: No se encontró el curso con ID ${course_id} en el sistema antiguo"
    exit 1
fi

# Crear directorios necesarios si no existen
mkdir -p moodle_data/course
mkdir -p moodledata_data/filedir

# Migrar solo los datos del curso específico
echo "Migrando datos del curso ${course_id}..."
cp -r "moodle_data_old/course/${course_id}" "moodle_data/course/"

# Migrar archivos asociados al curso
echo "Migrando archivos del curso..."
if [ -d "moodledata_data_old/filedir" ]; then
    # Buscar y copiar archivos relacionados con el curso
    find "moodledata_data_old/filedir" -type f -exec grep -l "course/${course_id}" {} \; | while read file; do
        cp --parents "$file" "moodledata_data/filedir/"
    done
fi

# Establecer permisos correctos
echo "Estableciendo permisos..."
chmod -R 777 moodle_data
chmod -R 777 moodledata_data
chmod -R 777 moodle_db
chmod -R 777 moodle_data_backup
chmod -R 777 moodledata_data_backup

# Establecer propietario correcto
echo "Estableciendo propietario..."
sudo chown -R 1001:1001 moodle_data
sudo chown -R 1001:1001 moodledata_data
sudo chown -R 1001:1001 moodle_db
sudo chown -R 1001:1001 moodle_data_backup
sudo chown -R 1001:1001 moodledata_data_backup

echo "Migración del curso ${course_id} completada."
echo "Ahora puedes ejecutar 'docker-compose up -d' para iniciar el sistema" 