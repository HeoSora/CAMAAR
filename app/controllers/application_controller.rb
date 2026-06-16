class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  stale_when_importmap_changes

  helper_method :current_user, :admin?, :current_admin_departamentos

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def admin?
    current_user&.perfil == "Administrador"
  end

  def current_admin_departamentos
    @current_admin_departamentos ||= current_user&.departamentos || Departamento.none
  end

  def require_login
    redirect_to login_path unless current_user
  end

  def require_admin
    redirect_to root_path, alert: "Acesso restrito a administradores" unless admin? && current_admin_departamentos.exists?
  end
end
