Rails.application.routes.draw do
  root "home#index"

  post "cadastrar", to: "users#create", as: :new_user
  get "cadastrar", to: "users#new", as: :new_user_view

  get "confirmar-email", to: "confirmations#new", as: :confirmation_view
  post "confirmar-email", to: "confirmations#create", as: :confirmation
  get "confirmar-email/:confirmation_token", to: "confirmations#edit", as: :edit_confirmation

  post "entrar", to: "sessions#create", as: :login
  get "sair", to: "sessions#destroy", as: :logout
  get "entrar", to: "sessions#new", as: :login_view

  post "senha/resetar", to: "passwords#create", as: :new_password
  get "senha/resetar", to: "passwords#new", as: :new_password_view
  get "senha/resetar/:password_reset_token", to: "passwords#edit", as: :edit_password
  put "senha/resetar/:password_reset_token", to: "passwords#update", as: :update_password

  put "conta", to: "users#update", as: :update_account
  get "conta", to: "users#edit", as: :account_view
  delete "conta", to: "users#destroy", as: :delete_account

  get "dashboard", to: "dashboard#index", as: :dashboard_view
end
