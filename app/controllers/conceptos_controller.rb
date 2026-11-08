class ConceptosController < ApplicationController
  before_action :set_concepto, only: %i[ show edit update destroy descargar ]
  before_action :editor_required, except: %i[index show descargar]

  # GET /conceptos/1/descargar
  def descargar
    unless @concepto.publicado? || current_user&.admin? || current_user&.editor?
      return redirect_to root_path, alert: "Acceso restringido."
    end
    unless @concepto.archivo.attached?
      return redirect_to @concepto, alert: "Este concepto no tiene archivo adjunto."
    end
    redirect_to rails_blob_path(@concepto.archivo, disposition: "attachment")
  end
  def index
    @conceptos = Concepto.publicados
    @conceptos = @conceptos.busqueda(params[:q]) if params[:q].present?
    if params[:tema].present?
      @conceptos = @conceptos.joins(:tema).where(temas: { nombre: params[:tema] })
    end
    @total = @conceptos.size
    @conceptos = @conceptos.order(:termino)

    if params[:todos].present?
      @pagina = 1
      @total_paginas = 1
    else
      @pagina = [ params[:page].to_i, 1 ].max
      @total_paginas = (@total.to_f / PER_PAGINA).ceil
      @total_paginas = 1 if @total_paginas.zero?
      @pagina = @total_paginas if @pagina > @total_paginas
      @conceptos = @conceptos.offset((@pagina - 1) * PER_PAGINA).limit(PER_PAGINA)
    end
  end

  # GET /conceptos/1 or /conceptos/1.json
  def show
  end

  # GET /conceptos/new
  def new
    @concepto = Concepto.new
  end

  # GET /conceptos/1/edit
  def edit
  end

  # POST /conceptos or /conceptos.json
  def create
    @concepto = Concepto.new(concepto_params)

    respond_to do |format|
      if @concepto.save
        format.html { redirect_to @concepto, notice: "Concepto was successfully created." }
        format.json { render :show, status: :created, location: @concepto }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @concepto.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /conceptos/1 or /conceptos/1.json
  def update
    respond_to do |format|
      if @concepto.update(concepto_params)
        format.html { redirect_to @concepto, notice: "Concepto was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @concepto }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @concepto.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /conceptos/1 or /conceptos/1.json
  def destroy
    @concepto.destroy!

    respond_to do |format|
      format.html { redirect_to conceptos_path, notice: "Concepto was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    PER_PAGINA = 100

    # Use callbacks to share common setup or constraints between actions.
    def set_concepto
      @concepto = Concepto.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def concepto_params
      params.expect(concepto: [ :termino, :definicion, :sinonimos, :categoria, :fuente, :estado, :tema_id, :archivo ])
    end
end
