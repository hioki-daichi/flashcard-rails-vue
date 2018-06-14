Rails.application.routes.draw do
  resources :books, only: [:index]

  namespace :ajax do
    resources :books, only: [:index]
  end
end
