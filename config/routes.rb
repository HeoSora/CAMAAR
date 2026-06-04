# config/routes.rb
Rails.application.routes.draw do
  # Autenticação
  get    "/login",   to: "sessoes#new",     as: :login
  post   "/login",   to: "sessoes#create"
  delete "/logout",  to: "sessoes#destroy", as: :logout

  # Primeiro acesso / definição de senha
  get   "/usuarios/mudar-senha", to: "usuarios#mudar_senha", as: :mudar_senha
  patch "/usuarios/mudar-senha", to: "usuarios#atualizar_senha"

  # Formulários - Issue #8
  resources :formularios, only: [:index, :show] do
    member do
      get :minha_resposta
    end
  end

  # Envio de respostas - Issue #18 (próxima sprint)
  resources :envio_formularios, only: [:new, :create]

  # Dashboard
  root to: "dashboard#index"
end
