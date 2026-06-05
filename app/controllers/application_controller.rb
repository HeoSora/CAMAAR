# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :autenticar_usuario!

  helper_method :usuario_logado, :discente_logado?, :docente_logado?, :admin_logado?

  private

  def autenticar_usuario!
    redirect_to login_path, alert: "Você precisa estar logado." unless session[:usuario_id]
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
    redirect_to root_path, alert: "Acesso restrito a discentes." unless discente_logado?
  end

  def exigir_docente!
    redirect_to root_path, alert: "Acesso restrito a docentes." unless docente_logado?
  end
end
