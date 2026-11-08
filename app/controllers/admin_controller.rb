class AdminController < ApplicationController
  before_action :admin_required

  def index
    redirect_to configuraciones_path
  end
end
