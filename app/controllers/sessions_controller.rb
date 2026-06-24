class SessionsController < ApplicationController
  def new
  end

  def create
    identifier = params[:identifier].to_s.strip

    user = Usuario.find_by(login: identifier) || Usuario.find_by(email: identifier)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      if user.perfil.to_s == "2" || user.perfil == :admin || (user.respond_to?(:admin?) && user.admin?)
        redirect_to admin_dashboard_path
      else
        redirect_to discente_dashboard_path
      end
    else
      flash.now[:alert] = "Usuário e/ou senha inválidos"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to login_path
  end
end
