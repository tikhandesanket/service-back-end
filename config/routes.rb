# config/routes.rb
Rails.application.routes.draw do
  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # API namespace
  namespace :api do
    namespace :v1 do
      # Auth routes
      post 'login',  to: 'auth#login'
      delete 'logout',  to: 'auth#logout'
      post 'guest',  to: 'auth#guest'
      get   'validate_token', to:'auth#validate_token'

      # User registration routes
      post 'register', to: 'users#create'   # POST /api/v1/register
      post 'users',    to: 'users#create'   # POST /api/v1/users
      get 'users',    to: 'users#index'   # GET /api/v1/users
     
    end
  end

end
