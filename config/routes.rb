Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  root 'static_pages#home' # => root_path
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'

  get    '/only_verdict_login',   to: 'sessions#only_verdict_login'
  post   '/only_verdict_login',   to: 'sessions#only_verdict_login_create'
  get    '/only_verdict_verify',  to: 'sessions#only_verdict_verify'
  get    '/diagnosis_login',      to: 'sessions#diagnosis_login'
  post   '/diagnosis_login',      to: 'sessions#diagnosis_login_create'
  get    '/diagnosis_logined',    to: 'diagnosis#diagnosis_logined'
  get    '/authenticate_login',   to: 'sessions#authenticate_login'
  post   '/authenticate_login',   to: 'sessions#authenticate_login_create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  get    '/verify',   to: 'sessions#verify'
  get    '/load',   to: 'sessions#load'
  delete '/logout',  to: 'sessions#destroy'

  resources :users do
    member do
      # /users/:id/ ...
      get :following, :followers
      # GET /users/1/following => following action
      # GET /users/1/followers => followers action
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end
