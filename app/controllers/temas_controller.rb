class TemasController < ApplicationController
  before_action :set_tema, only: %i[ show edit update destroy ]
  before_action :editor_required, except: %i[index show]

  # GET /temas or /temas.json
  def index
    @temas = Tema.order(:nombre)
  end

  # GET /temas/1 or /temas/1.json
  def show
  end

  # GET /temas/new
  def new
    @tema = Tema.new
  end

  # GET /temas/1/edit
  def edit
  end

  # POST /temas or /temas.json
  def create
    @tema = Tema.new(tema_params)

    respond_to do |format|
      if @tema.save
        format.html { redirect_to @tema, notice: "Tema was successfully created." }
        format.json { render :show, status: :created, location: @tema }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @tema.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /temas/1 or /temas/1.json
  def update
    respond_to do |format|
      if @tema.update(tema_params)
        format.html { redirect_to @tema, notice: "Tema was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @tema }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @tema.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /temas/1 or /temas/1.json
  def destroy
    @tema.destroy!

    respond_to do |format|
      format.html { redirect_to temas_path, notice: "Tema was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tema
      @tema = Tema.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def tema_params
      params.expect(tema: [ :nombre, :descripcion ])
    end
end
