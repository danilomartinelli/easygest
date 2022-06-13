Rails.application.routes.draw do
  root "home#index"

  post "cadastrar", to: "users#create", as: :new_user
  get "cadastrar", to: "users#new", as: :new_user_view

  resources :confirmations, only: [:create, :edit, :new], path: "confirmar-email", param: :confirmation_token
end
