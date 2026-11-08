class ReferenciasController < ApplicationController
  before_action :set_referencia, only: %i[ show edit update destroy ]
  before_action :editor_required, except: %i[index show]

  # GET /referencias or /referencias.json
  def index
    @referencias = Referencia.all
  end

  # GET /referencias/1 or /referencias/1.json
  def show
  end

  # GET /referencias/new
  def new
    @referencia = Referencia.new
  end

  # GET /referencias/1/edit
  def edit
  end

  # POST /referencias or /referencias.json
  def create
    @referencia = Referencia.new(referencia_params)

    respond_to do |format|
      if @referencia.save
        format.html { redirect_to @referencia, notice: "Referencia was successfully created." }
        format.json { render :show, status: :created, location: @referencia }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @referencia.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /referencias/1 or /referencias/1.json
  def update
    respond_to do |format|
      if @referencia.update(referencia_params)
        format.html { redirect_to @referencia, notice: "Referencia was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @referencia }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @referencia.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /referencias/1 or /referencias/1.json
  def destroy
    @referencia.destroy!

    respond_to do |format|
      format.html { redirect_to referencias_path, notice: "Referencia was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_referencia
      @referencia = Referencia.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def referencia_params
      params.expect(referencia: [ :concepto_id, :documento_id ])
    end
end
