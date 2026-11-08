json.extract! enlace, :id, :seccion_id, :titulo, :url, :descripcion, :orden, :created_at, :updated_at
json.seccion_titulo enlace.seccion.titulo
json.url enlace_url(enlace, format: :json)