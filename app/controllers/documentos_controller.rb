class DocumentosController < ApplicationController
  before_action :set_documento, only: %i[ show edit update destroy descargar ]
  before_action :editor_required, except: %i[index show descargar]

  # GET /documentos/1/descargar
  def descargar
    unless @documento.publicado? || current_user&.admin? || current_user&.editor?
      return redirect_to root_path, alert: "Acceso restringido."
    end
    redirect_to rails_blob_path(@documento.archivo, disposition: "attachment")
  end

  # GET /documentos or /documentos.json
  def index
    @documentos = Documento.publicados
    @documentos = @documentos.busqueda(params[:q]) if params[:q].present?
    @documentos = @documentos.where("autores ILIKE ?", "%#{params[:autor]}%") if params[:autor].present?
    if params[:decada].present? && params[:decada] =~ /\A(\d{4}) - (\d{4})\z/
      @documentos = @documentos.where(anio: Regexp.last_match(1).to_i..Regexp.last_match(2).to_i)
    end
    @documentos = @documentos.where(tipo: params[:tipo]) if params[:tipo].present? && Documento.tipos.key?(params[:tipo])
    orden = %w[titulo anio autores].include?(params[:orden]) ? params[:orden] : "anio"
    @total = @documentos.size
    @documentos = @documentos.order(orden => :desc).limit(100)
  end

  # GET /documentos/1 or /documentos/1.json
  def show
  end

  # GET /documentos/new
  def new
    @documento = Documento.new
  end

  # GET /documentos/1/edit
  def edit
  end

  # POST /documentos or /documentos.json
  def create
    @documento = Documento.new(documento_params)

    respond_to do |format|
      if @documento.save
        format.html { redirect_to @documento, notice: "Documento was successfully created." }
        format.json { render :show, status: :created, location: @documento }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @documento.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /documentos/1 or /documentos/1.json
  def update
    respond_to do |format|
      if @documento.update(documento_params)
        format.html { redirect_to @documento, notice: "Documento was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @documento }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @documento.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /documentos/1 or /documentos/1.json
  def destroy
    @documento.destroy!

    respond_to do |format|
      format.html { redirect_to documentos_path, notice: "Documento was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_documento
      @documento = Documento.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def documento_params
      params.expect(documento: [ :titulo, :autores, :anio, :resumen, :referencia, :tipo, :estado, :url, :doi, :archivo ])
    end
end
