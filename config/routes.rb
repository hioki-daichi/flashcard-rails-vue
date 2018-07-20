Rails.application.routes.draw do
  root to: 'homes#welcome'

  namespace :api do
    post :auth, to: 'authentication#authenticate'
    resources :books, only: [:index, :create, :update, :destroy] do
      collection do
        post :import
      end

      member do
        get :export
        patch :sort
      end

      resources :pages, only: [:index, :create, :update, :destroy] do
        member do
          patch :sort
        end
      end
    end
  end

  get '*path', to: 'homes#redirect_to_root'
end
