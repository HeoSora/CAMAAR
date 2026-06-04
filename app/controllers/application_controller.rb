# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :autenticar_usuario!

  helper_method :usuario_logado, :discente_logado?, :docente_logado?, :admin_logado?

  private

  def autenticar_usuario!
    unless session[:usuario_id]
      redirect_to login_path, alert: "Você precisa estar logado para acessar esta página."
    end
  end

  def usuario_logado
    @usuario_logado ||= Usuario.find_by(id: session[:usuario_id])
  end

  def discente_atual
    @discente_atual ||= usuario_logado&.discente
  end

  def docente_atual
    @docente_atual ||= usuario_logado&.docente
  end

  def discente_logado?
    usuario_logado&.discente?
  end

  def docente_logado?
    usuario_logado&.docente?
  end

  def admin_logado?
    usuario_logado&.admin?
  end

  def exigir_discente!
    unless discente_logado?
      redirect_to root_path, alert: "Acesso restrito a discentes."
    end
  end

  def exigir_docente!
    unless docente_logado?
      redirect_to root_path, alert: "Acesso restrito a docentes."
    end
  end

  def exigir_admin!
    unless admin_logado?
      redirect_to root_path, alert: "Acesso restrito a administradores."
    end
  end
end
