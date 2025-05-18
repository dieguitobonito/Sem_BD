# Cómo leer un archivo en podman
psql -h localhost -U postgres -d streaming_service -f $PATH
# Exportar la base de datos
pg_dump -h localhost -p 5432 -U postgres -d streaming_service -f name
