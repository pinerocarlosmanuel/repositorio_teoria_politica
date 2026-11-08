class ParticularidadesController < ApplicationController
  before_action :set_particularidad, only: %i[ show edit update destroy ]
  before_action :editor_required, except: %i[index show]

  # GET /particularidades or /particularidades.json
  def index
    @particularidades = Particularidad.order(:titulo)
  end

  # GET /particularidades/1 or /particularidades/1.json
  def show
  end

  # GET /particularidades/new
  def new
    @particularidad = Particularidad.new
  end

  # GET /particularidades/1/edit
  def edit
  end

  # POST /particularidades or /particularidades.json
  def create
    @particularidad = Particularidad.new(particularidad_params)

    respond_to do |format|
      if @particularidad.save
        format.html { redirect_to @particularidad, notice: "Particularidad was successfully created." }
        format.json { render :show, status: :created, location: @particularidad }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @particularidad.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /particularidades/1 or /particularidades/1.json
  def update
    respond_to do |format|
      if @particularidad.update(particularidad_params)
        format.html { redirect_to @particularidad, notice: "Particularidad was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @particularidad }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @particularidad.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /particularidades/1 or /particularidades/1.json
  def destroy
    @particularidad.destroy!

    respond_to do |format|
      format.html { redirect_to particularidades_path, notice: "Particularidad was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_particularidad
      @particularidad = Particularidad.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def particularidad_params
      params.expect(particularidad: [ :titulo, :descripcion, :sistema_id ])
    end
end
