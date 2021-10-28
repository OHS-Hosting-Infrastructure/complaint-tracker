class CreateIssueMonitoringReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :issue_monitoring_reviews do |t|
      t.string :issue_id, null: false
      t.string :review_id, null: false
      t.date :start_date, null: false

      t.timestamps
    end
  end
end
