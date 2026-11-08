class EnlaceSistemaGobiernosController < ApplicationController
  before_action :set_sistema_gobierno
  before_action :editor_required

  # POST /sistemas_gobierno/:sistema_gobierno_id/enlace_sistema_gobiernos
  def create
    @enlace = @sistema_gobierno.enlace_sistema_gobiernos.new(enlace_params)

    if @enlace.save
      redirect_to sistemas_gobierno_path(@sistema_gobierno), notice: "Enlace añadido."
    else
      redirect_to sistemas_gobierno_path(@sistema_gobierno), alert: "No se pudo añadir el enlace: #{@enlace.errors.full_messages.join(", ")}"
    end
  end

  # DELETE /enlace_sistema_gobiernos/1
  def destroy
    @enlace = EnlaceSistemaGobierno.find(params.expect(:id))
    @enlace.destroy!

    redirect_to sistemas_gobierno_path(@enlace.sistema_gobierno), notice: "Enlace eliminado.", status: :see_other
  end

  private
    def set_sistema_gobierno
      @sistema_gobierno = SistemaGobierno.find(params[:sistemas_gobierno_id]) if params[:sistemas_gobierno_id].present?
    end

    def enlace_params
      params.expect(enlace_sistema_gobierno: [ :titulo, :url, :orden ])
    end
end
