json.extract! chat_log, :id, :pregunta, :respuesta, :regla_id, :user_id, :created_at, :updated_at
json.url chat_log_url(chat_log, format: :json)
