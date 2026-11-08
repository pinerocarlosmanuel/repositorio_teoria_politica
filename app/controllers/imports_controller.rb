class ImportsController < ApplicationController
  before_action :admin_required

  def index
    @resultado = nil
  end

  def conceptos
    importar(:conceptos)
  end

  def paises
    importar(:paises)
  end

  private

  def importar(tipo)
    archivo = params[:archivo]
    unless archivo.respond_to?(:path) && File.exist?(archivo.path)
      flash[:alert] = "Selecciona un archivo CSV válido."
      return redirect_to imports_index_path
    end
    @resultado = ImportadorCsv.public_send(tipo, archivo)
    flash.now[:notice] = "Importación de #{tipo}: #{@resultado[:cargados]} filas cargadas, #{@resultado[:errores].size} errores."
    render :index
  rescue CSV::MalformedCSVError => e
    flash[:alert] = "CSV inválido: #{e.message}"
    redirect_to imports_index_path
  end
end
