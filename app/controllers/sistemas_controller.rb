class SistemasController < ApplicationController
  before_action :set_sistema, only: %i[ show edit update destroy ]
  before_action :editor_required, except: %i[index show]

  # GET /sistemas or /sistemas.json
  def index
    @sistemas = Sistema.includes(:pais, :particularidades).order(:pais_id)
  end

  # GET /sistemas/1 or /sistemas/1.json
  def show
  end

  # GET /sistemas/new
  def new
    @sistema = Sistema.new
  end

  # GET /sistemas/1/edit
  def edit
  end

  # POST /sistemas or /sistemas.json
  def create
    @sistema = Sistema.new(sistema_params)

    respond_to do |format|
      if @sistema.save
        format.html { redirect_to @sistema, notice: "Sistema was successfully created." }
        format.json { render :show, status: :created, location: @sistema }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @sistema.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /sistemas/1 or /sistemas/1.json
  def update
    respond_to do |format|
      if @sistema.update(sistema_params)
        format.html { redirect_to @sistema, notice: "Sistema was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @sistema }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @sistema.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /sistemas/1 or /sistemas/1.json
  def destroy
    @sistema.destroy!

    respond_to do |format|
      format.html { redirect_to sistemas_path, notice: "Sistema was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sistema
      @sistema = Sistema.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def sistema_params
      params.expect(sistema: [ :tipo, :descripcion, :pais_id ])
    end
end
