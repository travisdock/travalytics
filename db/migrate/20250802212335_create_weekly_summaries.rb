class CreateWeeklySummaries < ActiveRecord::Migration[8.0]
  def change
    create_table :weekly_summaries do |t|
      t.references :site, null: false, foreign_key: true
      t.text :content
      t.datetime :generated_at

      t.timestamps
    end
  end
end
