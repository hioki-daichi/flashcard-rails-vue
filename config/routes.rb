Rails.application.routes.draw do
  root to: 'homes#welcome'

  namespace :api do
    post :auth, to: 'authentication#authenticate'
    resources :books, only: [:index, :create, :update, :destroy] do
      collection do
        post :import
        patch :positions
      end

      member do
        get :export
        patch :page_positions
      end
      resources :pages, only: [:index, :create, :update, :destroy]
    end
  end

  get '*path', to: 'homes#redirect_to_root'
end
