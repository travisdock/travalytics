class DropWeeklySummaries < ActiveRecord::Migration[8.1]
  def change
    drop_table :weekly_summaries
  end
end
