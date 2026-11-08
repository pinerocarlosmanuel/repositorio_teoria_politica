class EnlacesController < ApplicationController
  before_action :set_enlace, only: %i[ show edit update destroy ]
  before_action :admin_required

  # GET /enlaces or /enlaces.json
  def index
    @enlaces = Enlace.order(:seccion_id, :orden, :titulo)
  end

  # GET /enlaces/1 or /enlaces/1.json
  def show
  end

  # GET /enlaces/new
  def new
    @enlace = Enlace.new
    @enlace.seccion_id = params.dig(:enlace, :seccion_id)
  end

  # GET /enlaces/1/edit
  def edit
  end

  # POST /enlaces or /enlaces.json
  def create
    @enlace = Enlace.new(enlace_params)

    respond_to do |format|
      if @enlace.save
        format.html { redirect_to @enlace, notice: "Enlace creado correctamente." }
        format.json { render :show, status: :created, location: @enlace }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @enlace.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /enlaces/1 or /enlaces/1.json
  def update
    respond_to do |format|
      if @enlace.update(enlace_params)
        format.html { redirect_to @enlace, notice: "Enlace actualizado correctamente.", status: :see_other }
        format.json { render :show, status: :ok, location: @enlace }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @enlace.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /enlaces/1 or /enlaces/1.json
  def destroy
    @enlace.destroy!

    respond_to do |format|
      format.html { redirect_to enlaces_path, notice: "Enlace eliminado.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_enlace
    @enlace = Enlace.find(params.expect(:id))
  end

  def enlace_params
    params.expect(enlace: [ :seccion_id, :titulo, :url, :descripcion, :orden ])
  end
end
