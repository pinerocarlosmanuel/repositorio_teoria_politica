class SistemasGobiernoController < ApplicationController
  before_action :set_sistema_gobierno, only: %i[ show edit update destroy ]
  before_action :editor_required, except: %i[index show]

  # GET /sistemas
  def index
    @sistemas = SistemaGobierno.ordenados_en_etapas
    @por_etapa = @sistemas.group_by(&:etapa)
  end

  # GET /sistemas_gobierno/1
  def show
  end

  # GET /sistemas_gobierno/new
  def new
    @sistema_gobierno = SistemaGobierno.new
  end

  # GET /sistemas_gobierno/1/edit
  def edit
  end

  # POST /sistemas_gobierno
  def create
    @sistema_gobierno = SistemaGobierno.new(sistema_gobierno_params)

    respond_to do |format|
      if @sistema_gobierno.save
        format.html { redirect_to sistemas_gobierno_path(@sistema_gobierno), notice: "Sistema de gobierno creado." }
        format.json { render :show, status: :created, location: sistemas_gobierno_path(@sistema_gobierno) }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @sistema_gobierno.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /sistemas_gobierno/1
  def update
    respond_to do |format|
      if @sistema_gobierno.update(sistema_gobierno_params)
        format.html { redirect_to sistemas_gobierno_path(@sistema_gobierno), notice: "Sistema de gobierno actualizado." }
        format.json { render :show, status: :ok, location: sistemas_gobierno_path(@sistema_gobierno) }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @sistema_gobierno.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /sistemas_gobierno/1
  def destroy
    @sistema_gobierno.destroy!

    respond_to do |format|
      format.html { redirect_to sistemas_path, notice: "Sistema de gobierno eliminado.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def set_sistema_gobierno
      @sistema_gobierno = SistemaGobierno.find(params.expect(:id))
    end

    def sistema_gobierno_params
      params.expect(sistema_gobierno: [ :nombre, :etapa, :descripcion, :orden, :estado, :imagen ])
    end
end
