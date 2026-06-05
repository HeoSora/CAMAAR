# config/routes.rb
Rails.application.routes.draw do
  get    "/login",  to: "sessoes#new",     as: :login
  post   "/login",  to: "sessoes#create"
  delete "/logout", to: "sessoes#destroy", as: :logout

  get   "/usuarios/mudar-senha", to: "usuarios#mudar_senha",    as: :mudar_senha
  patch "/usuarios/mudar-senha", to: "usuarios#atualizar_senha"

  # Issue #8
  resources :formularios, only: [:index, :show] do
    member do
      get :minha_resposta
    end
  end

  # Issue #18 (próxima issue)
  resources :envio_formularios, only: [:new, :create]

  root to: "dashboard#index"
Rails.application.routes.draw do
  #get "sessions/new"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root "sessions#new"

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  get "/admin", to: "dashboards#admin", as: :admin_dashboard
  get "/discente", to: "dashboards#discente", as: :discente_dashboard
end
