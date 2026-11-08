class RecursosDidacticosController < ApplicationController
  before_action :set_recurso_didactico, only: %i[ show edit update destroy descargar ]
  before_action :editor_required, except: %i[index show descargar]

  # GET /recursos_didacticos/1/descargar
  def descargar
    unless @recurso_didactico.publicado? || current_user&.admin? || current_user&.editor?
      return redirect_to root_path, alert: "Acceso restringido."
    end
    redirect_to rails_blob_path(@recurso_didactico.archivo, disposition: "attachment")
  end

  # GET /recurso_didacticos or /recurso_didacticos.json
  def index
    @recurso_didacticos = params[:q].present? ? RecursoDidactico.publicados.busqueda(params[:q]) : RecursoDidactico.publicados.order(:titulo)
  end

  # GET /recurso_didacticos/1 or /recurso_didacticos/1.json
  def show
  end

  # GET /recurso_didacticos/new
  def new
    @recurso_didactico = RecursoDidactico.new
  end

  # GET /recurso_didacticos/1/edit
  def edit
  end

  # POST /recurso_didacticos or /recurso_didacticos.json
  def create
    @recurso_didactico = RecursoDidactico.new(recursos_didacticos_params)

    respond_to do |format|
      if @recurso_didactico.save
        format.html { redirect_to @recurso_didactico, notice: "Recurso didactico was successfully created." }
        format.json { render :show, status: :created, location: @recurso_didactico }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @recurso_didactico.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /recurso_didacticos/1 or /recurso_didacticos/1.json
  def update
    respond_to do |format|
      if @recurso_didactico.update(recursos_didacticos_params)
        format.html { redirect_to @recurso_didactico, notice: "Recurso didactico was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @recurso_didactico }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @recurso_didactico.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /recurso_didacticos/1 or /recurso_didacticos/1.json
  def destroy
    @recurso_didactico.destroy!

    respond_to do |format|
      format.html { redirect_to recurso_didacticos_path, notice: "Recurso didactico was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recurso_didactico
      @recurso_didactico = RecursoDidactico.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def recursos_didacticos_params
      params.expect(recurso_didactico: [ :titulo, :descripcion, :tipo, :referencia, :url, :estado, :archivo ])
    end
end
