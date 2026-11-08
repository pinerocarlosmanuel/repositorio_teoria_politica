json.extract! pais, :id, :nombre, :continente, :region, :descripcion, :destacado, :created_at, :updated_at
json.url pais_url(pais, format: :json)
