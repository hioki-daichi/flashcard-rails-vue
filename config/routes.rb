Rails.application.routes.draw do
  root to: 'homes#welcome'

  resources :books, only: [:index] do
    resources :pages, only: [:index]
  end

  namespace :ajax do
    resources :books, only: [:index, :create] do
      resources :pages, only: [:index, :create]
    end
  end

  get '*path', to: 'homes#redirect_to_root'
end
