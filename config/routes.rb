Rails.application.routes.draw do
  resources :complaints, only: %i[index show]

  # session pages
  get "/oauth2-client/login/oauth2/code/", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :issue_tta_reports, only: [:new, :create]

  root to: "pages#welcome"
end
