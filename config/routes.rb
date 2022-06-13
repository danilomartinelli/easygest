Rails.application.routes.draw do
  root "home#index"

  post "cadastrar", to: "users#create", as: :new_user
  get "cadastrar", to: "users#new", as: :new_user_view

  get "confirmar-email", to: "confirmations#new", as: :confirmation_view
  post "confirmar-email", to: "confirmations#create", as: :confirmation
  get "confirmar-email/:confirmation_token", to: "confirmations#edit", as: :edit_confirmation

  post "entrar", to: "sessions#create", as: :login
  delete "sair", to: "sessions#destroy", as: :logout
  get "entrar", to: "sessions#new", as: :login_view
end
