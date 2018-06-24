Rails.application.routes.draw do
  root to: 'homes#welcome'

  namespace :api do
    resources :books, only: [:index, :create, :destroy] do
      resources :pages, only: [:index, :create, :destroy]
    end
  end

  get '*path', to: 'homes#redirect_to_root'
end
