class SeccionesController < ApplicationController
  before_action :set_seccion, only: %i[ show edit update destroy ]
  before_action :admin_required, except: %i[ acerca teoria_conspiracion ]

  # Páginas públicas con información + enlaces (estilo HC)
  def acerca
    @secciones = Seccion.publicas.to_a.sort_by { |s| Seccion::CLAVES_PUBLICAS.index(s.clave) || 99 }
  end

  def teoria_conspiracion
    @seccion = Seccion.por_clave("teoria_conspiracion")
    render :pagina
  end

  # GET /secciones or /secciones.json
  def index
    @secciones = Seccion.order(:clave)
  end

  # GET /secciones/1 or /secciones/1.json
  def show
  end

  # GET /secciones/new
  def new
    @seccion = Seccion.new
  end

  # GET /secciones/1/edit
  def edit
  end

  # POST /secciones or /secciones.json
  def create
    @seccion = Seccion.new(seccion_params)

    respond_to do |format|
      if @seccion.save
        format.html { redirect_to @seccion, notice: "Sección creada correctamente." }
        format.json { render :show, status: :created, location: @seccion }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @seccion.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /secciones/1 or /secciones/1.json
  def update
    respond_to do |format|
      if @seccion.update(seccion_params)
        format.html { redirect_to @seccion, notice: "Sección actualizada correctamente.", status: :see_other }
        format.json { render :show, status: :ok, location: @seccion }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @seccion.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /secciones/1 or /secciones/1.json
  def destroy
    @seccion.destroy!

    respond_to do |format|
      format.html { redirect_to secciones_path, notice: "Sección eliminada.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_seccion
    @seccion = Seccion.find(params.expect(:id))
  end

  def seccion_params
    params.expect(seccion: [ :clave, :titulo, :cuerpo ])
  end
end
