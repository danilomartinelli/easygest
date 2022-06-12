Rails.application.routes.draw do
  root "home#index"

  post "cadastrar", to: "users#create", as: :new_user
  get "cadastrar", to: "users#new", as: :new_user_view
end
