Rails.application.routes.draw do
  resources :grantees
  resources :complaints, only: %i[index show]
  delete "issue_tta_report/unlink_report/:issue_id", to: "issue_tta_reports#unlink", as: :unlink_tta_report
  # session pages
  get "/oauth2-client/login/oauth2/code/", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :issue_tta_reports, only: [:create, :update]

  root to: "pages#welcome"
end
