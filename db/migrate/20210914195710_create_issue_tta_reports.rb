class CreateIssueTtaReports < ActiveRecord::Migration[6.1]
  def change
    create_table :issue_tta_reports do |t|
      t.string :issue_id
      t.string :tta_report_display_id
      t.integer :tta_report_id

      t.timestamps
    end
  end
end
