json.extract! documento, :id, :titulo, :autores, :anio, :resumen, :referencia, :tipo, :estado, :url, :doi, :created_at, :updated_at
json.url documento_url(documento, format: :json)
