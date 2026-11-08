json.extract! recurso_didactico, :id, :titulo, :descripcion, :tipo, :referencia, :url, :estado, :created_at, :updated_at
json.url recurso_didactico_url(recurso_didactico, format: :json)
