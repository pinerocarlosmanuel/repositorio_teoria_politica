class ReglasController < ApplicationController
  before_action :set_regla, only: %i[ show edit update destroy ]
  before_action :admin_required

  # GET /reglas or /reglas.json
  def index
    @reglas = Regla.order(:intent)
  end

  # GET /reglas/1 or /reglas/1.json
  def show
  end

  # GET /reglas/new
  def new
    @regla = Regla.new
  end

  # GET /reglas/1/edit
  def edit
  end

  # POST /reglas or /reglas.json
  def create
    @regla = Regla.new(regla_params)

    respond_to do |format|
      if @regla.save
        format.html { redirect_to @regla, notice: "Regla was successfully created." }
        format.json { render :show, status: :created, location: @regla }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @regla.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /reglas/1 or /reglas/1.json
  def update
    respond_to do |format|
      if @regla.update(regla_params)
        format.html { redirect_to @regla, notice: "Regla was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @regla }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @regla.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /reglas/1 or /reglas/1.json
  def destroy
    @regla.destroy!

    respond_to do |format|
      format.html { redirect_to reglas_path, notice: "Regla was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_regla
      @regla = Regla.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def regla_params
      params.expect(regla: [ :intent, :keywords, :respuesta, :activa ])
    end
end
