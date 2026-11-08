class EnlaceConceptosController < ApplicationController
  before_action :set_concepto
  before_action :editor_required

  # POST /conceptos/:concepto_id/enlace_conceptos
  def create
    @enlace_concepto = @concepto.enlace_conceptos.new(enlace_concepto_params)

    if @enlace_concepto.save
      redirect_to @concepto, notice: "Enlace añadido."
    else
      redirect_to @concepto, alert: "No se pudo añadir el enlace: #{@enlace_concepto.errors.full_messages.join(", ")}"
    end
  end

  # DELETE /enlace_conceptos/1
  def destroy
    @enlace_concepto = EnlaceConcepto.find(params.expect(:id))
    @enlace_concepto.destroy!

    redirect_to @enlace_concepto.concepto, notice: "Enlace eliminado.", status: :see_other
  end

  private
    def set_concepto
      @concepto = Concepto.find(params[:concepto_id]) if params[:concepto_id].present?
    end

    def enlace_concepto_params
      params.expect(enlace_concepto: [ :titulo, :url, :orden ])
    end
end
