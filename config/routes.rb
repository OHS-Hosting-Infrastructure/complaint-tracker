Rails.application.routes.draw do
  resources :complaints, only: %i[index show]
  delete "complaint/:id/unlink_tta_report", to: "complaints#unlink_tta_report", as: :unlink_tta_report
  # session pages
  get "/oauth2-client/login/oauth2/code/", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :issue_tta_reports, only: [:create, :update]

  root to: "pages#welcome"
end
