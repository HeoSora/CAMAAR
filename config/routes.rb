# config/routes.rb
Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "sessions#new"

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  get "/definir_senha", to: "passwords#edit", as: :definir_senha
  patch "/definir_senha", to: "passwords#update", as: :definir_senha_update

  get "/admin", to: "dashboards#admin", as: :admin_dashboard
  get "/discente", to: "dashboards#discente", as: :discente_dashboard

  resources :formularios, only: [ :index, :show ] do
    member do
      get :minha_resposta
    end
  end

  resources :turmas, only: [ :index, :show ]
end
