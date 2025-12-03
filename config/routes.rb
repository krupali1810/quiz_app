Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
  
  # Quiz taking routes
  resources :quizzes, only: [:show] do
    member do
      get :start
      post :submit
      get :result
    end
  end
  
  # Admin routes
  get "admin/login", to: "admin#login"
  post "admin/login", to: "admin#create_session"
  delete "admin/logout", to: "admin#destroy_session"
  get "admin", to: "admin#dashboard"
  
  # Admin quiz management
  namespace :admin do
    resources :quizzes do
      member do
        patch :toggle_published
      end
      resources :questions, except: [:show]
    end
    resources :quiz_attempts, only: [:index, :show, :destroy] do
      collection do
        delete :bulk_destroy
      end
    end
  end
end
