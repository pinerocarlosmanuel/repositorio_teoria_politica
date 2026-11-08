json.extract! seccion, :id, :clave, :titulo, :cuerpo, :created_at, :updated_at
json.enlaces seccion.enlaces_ordenados do |enlace|
  json.extract! enlace, :id, :titulo, :url, :descripcion, :orden
end
json.url seccion_url(seccion, format: :json)