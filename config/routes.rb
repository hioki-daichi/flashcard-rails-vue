Rails.application.routes.draw do
  resources :books, only: [:index] do
    resources :pages, only: [:index]
  end

  namespace :ajax do
    resources :books, only: [:index] do
      resources :pages, only: [:index]
    end
  end
end
