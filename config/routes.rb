Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  root to: "homes#welcome"

  # Auth
  post "/api/auth", to: "api/authentication#authenticate"

  # Books
  post "/api/books/import", to: "api/books#import"
  get "/api/books/:book_sub/export", to: "api/books#export"

  # Pages
  get "/api/books/:book_sub/pages", to: "api/pages#index"

  match "/api/", via: :all, to: "api/errors#routing_error"
  match "/api/*path", via: :all, to: "api/errors#routing_error"

  get "*path", to: "homes#redirect_to_root"
end
