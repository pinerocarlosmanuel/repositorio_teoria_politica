class PaisesController < ApplicationController
  before_action :set_pais, only: %i[ show edit update destroy ]
  before_action :editor_required, except: %i[index show cuba comparativa]

  # GET /paises or /paises.json
  def index
    @paises = Pais.includes(:sistemas).order(:nombre)
  end

  def cuba
    @cuba = Pais.destacados.first
    @sistemas = @cuba ? Sistema.where(pais: @cuba).order(:tipo) : []
    @particularidades = Particularidad.where(sistema: @sistemas).order(:titulo) if @sistemas.any?
  end

  def comparativa
    @paises = Pais.order(:nombre)
    @tipos_sistema = Sistema.tipos.keys
    @por_pais = Pais.all.to_h { |p| [p.id, Sistema.where(pais: p).pluck(:tipo, :descripcion)] }
  end

  # GET /paises/1 or /paises/1.json
  def show
  end

  # GET /paises/new
  def new
    @pais = Pais.new
  end

  # GET /paises/1/edit
  def edit
  end

  # POST /paises or /paises.json
  def create
    @pais = Pais.new(pais_params)

    respond_to do |format|
      if @pais.save
        format.html { redirect_to @pais, notice: "Pais was successfully created." }
        format.json { render :show, status: :created, location: @pais }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @pais.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /paises/1 or /paises/1.json
  def update
    respond_to do |format|
      if @pais.update(pais_params)
        format.html { redirect_to @pais, notice: "Pais was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @pais }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @pais.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /paises/1 or /paises/1.json
  def destroy
    @pais.destroy!

    respond_to do |format|
      format.html { redirect_to paises_path, notice: "Pais was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pais
      @pais = Pais.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def pais_params
      params.expect(pais: [ :nombre, :continente, :region, :descripcion, :destacado ])
    end
end
