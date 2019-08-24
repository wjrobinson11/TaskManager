Rails.application.routes.draw do
  root to: 'tasks#index'
  get '/dashboard', to: 'pages#dashboard'
  
  devise_for :users, path: 'auth', controllers: {
    registrations: "auth/registrations",
    sessions: "auth/sessions"
  }

  resources :tasks
  resources :companies
  resources :users
end
