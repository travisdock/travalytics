Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :users, only: [ :new, :create ]

  # API endpoints for tracking
  scope "track/:tracking_id" do
    resources :events, only: [ :create ]
  end

  # Site management
  resources :sites do
    member do
      get :page_durations
      get :weekly_summary
      post :generate_weekly_summary
    end
  end

  # User settings
  resource :settings, only: [ :edit, :update ] do
    patch :update_password
  end

  # External events
  resources :external_events, except: [ :show ]

  # Dashboard routes
  resource :dashboard, only: [ :show ] do
    member do
      get :events
    end
  end

  # Public analytics script
  get "analytics.js", to: "public#analytics_script"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "dashboards#show"
end
