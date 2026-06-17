Rails.application.routes.draw do
  # get "sessions/new"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*.
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
  resources :turmas, only: [:index, :show]

  get "/avaliacao", to: "dashboards#admin_avaliacao", as: :admin_avaliacao_dashboard
  get "/gerenciamento", to: "dashboards#admin_gerenciamento", as: :admin_gerenciamento_dashboard

  get "/definir_senha", to: "passwords#edit", as: :definir_senha
  patch "/definir_senha", to: "passwords#update", as: :definir_senha_update

  # usando o controller existente
  # get '/json/importar', to: 'json#importar'
  # get '/json/resultados', to: 'json#resultados'
  post "admin/importar_json", to: "dashboards#importar_json", as: :importar_json

  resources :templates, only: [ :index ]
  resources :turmas, only: [ :index, :show ]
end
