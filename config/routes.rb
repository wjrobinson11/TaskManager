Rails.application.routes.draw do
  root to: 'tasks#index'
  get '/dashboard', to: 'pages#dashboard'
  
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  devise_scope :user do
    get "/users", to: "users/registrations#index"
    delete "/users/:id", to: "users/registrations#destroy", as: "destroy_user_registration"
  end

  resources :tasks
  resources :companies
end
