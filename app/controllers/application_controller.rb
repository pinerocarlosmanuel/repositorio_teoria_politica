class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :admin_required_path?

  private

  def admin_required
    return if current_user&.admin?

    redirect_to root_path, alert: "Acceso restringido."
  end

  def editor_required
    return if current_user&.admin? || current_user&.editor?

    redirect_to root_path, alert: "Acceso restringido."
  end
end
