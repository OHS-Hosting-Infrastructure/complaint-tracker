Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/", to: "complaints#index", as: :root

  get "/oauth2-client/login/oauth2/code/", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end
