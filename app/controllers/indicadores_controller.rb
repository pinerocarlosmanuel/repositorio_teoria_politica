class IndicadoresController < ApplicationController
  before_action :set_indicador, only: %i[ show edit update destroy ]
  before_action :editor_required, except: %i[index show]

  # GET /indicadores or /indicadores.json
  def index
    @indicadores = Indicador.order(:nombre)
  end

  # GET /indicadores/1 or /indicadores/1.json
  def show
  end

  # GET /indicadores/new
  def new
    @indicador = Indicador.new
  end

  # GET /indicadores/1/edit
  def edit
  end

  # POST /indicadores or /indicadores.json
  def create
    @indicador = Indicador.new(indicador_params)

    respond_to do |format|
      if @indicador.save
        format.html { redirect_to @indicador, notice: "Indicador was successfully created." }
        format.json { render :show, status: :created, location: @indicador }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @indicador.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /indicadores/1 or /indicadores/1.json
  def update
    respond_to do |format|
      if @indicador.update(indicador_params)
        format.html { redirect_to @indicador, notice: "Indicador was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @indicador }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @indicador.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /indicadores/1 or /indicadores/1.json
  def destroy
    @indicador.destroy!

    respond_to do |format|
      format.html { redirect_to indicadores_path, notice: "Indicador was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_indicador
      @indicador = Indicador.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def indicador_params
      params.expect(indicador: [ :nombre, :descripcion, :metodo, :variable_id ])
    end
end
