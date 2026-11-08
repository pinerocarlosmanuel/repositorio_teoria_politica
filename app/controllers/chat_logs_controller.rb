class ChatLogsController < ApplicationController
  before_action :set_chat_log, only: %i[ show edit update destroy ]
  before_action :admin_required

  # GET /chat_logs or /chat_logs.json
  def index
    @chat_logs = ChatLog.order(created_at: :desc).limit(100)
  end

  # GET /chat_logs/1 or /chat_logs/1.json
  def show
  end

  # GET /chat_logs/new
  def new
    @chat_log = ChatLog.new
  end

  # GET /chat_logs/1/edit
  def edit
  end

  # POST /chat_logs or /chat_logs.json
  def create
    @chat_log = ChatLog.new(chat_log_params)

    respond_to do |format|
      if @chat_log.save
        format.html { redirect_to @chat_log, notice: "Chat log was successfully created." }
        format.json { render :show, status: :created, location: @chat_log }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @chat_log.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /chat_logs/1 or /chat_logs/1.json
  def update
    respond_to do |format|
      if @chat_log.update(chat_log_params)
        format.html { redirect_to @chat_log, notice: "Chat log was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @chat_log }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @chat_log.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /chat_logs/1 or /chat_logs/1.json
  def destroy
    @chat_log.destroy!

    respond_to do |format|
      format.html { redirect_to chat_logs_path, notice: "Chat log was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat_log
      @chat_log = ChatLog.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def chat_log_params
      params.expect(chat_log: [ :pregunta, :respuesta, :regla_id, :user_id ])
    end
end
