class ChatController < ApplicationController
  before_action :admin_required, only: :historial

  def index
    @ejemplos = [
      "¿Qué es el poder político?",
      "Definición de hegemonía",
      "Documentos sobre Estado",
      "Sistema electoral de Cuba",
      "Recursos sobre ciberseguridad",
      "¿Qué es el sistema político de Rusia?"
    ]
  end

  def consultar
    pregunta = params[:pregunta].to_s.strip
    resultado = MotorReglas.responder(pregunta)
    if user_signed_in?
      ChatLog.create!(pregunta: pregunta, respuesta: resultado[:respuesta], regla: resultado[:regla], user: current_user)
    end
    render json: { respuesta: resultado[:respuesta], matched: resultado[:matched] }
  end

  def historial
    @logs = ChatLog.order(created_at: :desc).limit(100)
  end
end
