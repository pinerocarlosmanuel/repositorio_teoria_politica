class ConfiguracionesController < ApplicationController
  before_action :admin_required

  SECCIONES = %w[portada acerca menu ajustes front usuarios secciones enlaces].freeze

  def index
    @seccion = seccion_valida
    @configuracion = Configuracion.reg(@seccion)
  end

  def update
    clave = params.dig(:configuracion, :clave)
    unless Configuracion::CLAVES.include?(clave)
      return redirect_to configuraciones_path, alert: "Sección de configuración no válida."
    end

    registro = Configuracion.where(clave: clave).first || Configuracion.new(clave: clave)
    registro.valor = valores_limpios(clave)

    if registro.save
      redirect_to configuraciones_path(seccion: clave), notice: "Cambios guardados correctamente.", status: :see_other
    else
      redirect_to configuraciones_path(seccion: clave), alert: "No se pudieron guardar los cambios."
    end
  end

  def crear_usuario
    @usuario = User.new(usuario_params)
    if @usuario.save
      redirect_to configuraciones_path(seccion: "usuarios"), notice: "Usuario creado correctamente.", status: :see_other
    else
      redirect_to configuraciones_path(seccion: "usuarios"),
                  alert: "No se pudo crear el usuario: #{@usuario.errors.full_messages.to_sentence}"
    end
  end

  def actualizar_usuario
    @usuario = User.find(params[:id])
    atributos = usuario_params
    atributos = atributos.except(:password, :password_confirmation) if atributos[:password].blank?

    if @usuario == current_user
      redirect_to configuraciones_path(seccion: "usuarios"), alert: "No puedes cambiar tu propio rol desde aquí."
    elsif @usuario.update(atributos)
      redirect_to configuraciones_path(seccion: "usuarios"), notice: "Usuario actualizado correctamente.", status: :see_other
    else
      redirect_to configuraciones_path(seccion: "usuarios"),
                  alert: "No se pudo actualizar el usuario: #{@usuario.errors.full_messages.to_sentence}"
    end
  end

  def eliminar_usuario
    @usuario = User.find(params[:id])
    if @usuario == current_user
      redirect_to configuraciones_path(seccion: "usuarios"), alert: "No puedes eliminar tu propia cuenta."
    else
      @usuario.destroy
      redirect_to configuraciones_path(seccion: "usuarios"), notice: "Usuario eliminado correctamente.", status: :see_other
    end
  end

  private

  def seccion_valida
    params[:seccion].in?(SECCIONES) ? params[:seccion] : "portada"
  end

  def valores_limpios(clave)
    raw = params.fetch(:configuracion, {}).fetch(:valor, {})

    if clave == Configuracion::CLAVE_MENU
      items = Array(raw[:items]).filter_map do |item|
        label = (item[:label] || item["label"]).to_s.strip
        next if label.blank?

        { label: label, url: (item[:url] || item["url"]).to_s.strip }
      end
      { menu_logo: raw[:menu_logo].to_s, items: items }
    else
      permitidos = Configuracion::VALORES_DEFECTO.fetch(clave, {}).keys
      raw.permit(permitidos).to_h
    end
  end

  def usuario_params
    params.require(:user).permit(:email, :nombre, :rol, :password, :password_confirmation)
  end
end
