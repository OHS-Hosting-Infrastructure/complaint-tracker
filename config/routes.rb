Rails.application.routes.draw do
  resources :complaints, only: %i[index show]
  resources :grantees, only: %i[show]

  # complaint links with TTA or IT-AMS
  resources :issue_tta_reports, only: [:create, :update]
  delete "issue_tta_report/unlink_report/:issue_id_tta",
    to: "issue_tta_reports#destroy", as: :unlink_tta_report
  resources :issue_monitoring_reviews, only: [:create, :update]
  delete "issue_monitoring_review/unlink_review/:issue_id_monitoring",
    to: "issue_monitoring_reviews#destroy", as: :unlink_monitoring_review

  # session pages
  get "/oauth2-client/login/oauth2/code/", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  root to: "pages#welcome"
end
