class SaveTtaStartDate < ActiveRecord::Migration[6.1]
  def change
    add_column :issue_tta_reports, :start_date, :date

    reversible do |dir|
      dir.up do
        # not accurate, but we don't have any real data yet anyway
        execute "UPDATE issue_tta_reports SET start_date = now()"
        change_column :issue_tta_reports, :start_date, :date, null: false
      end
    end
  end
end
