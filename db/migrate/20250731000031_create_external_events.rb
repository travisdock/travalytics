class CreateExternalEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :external_events do |t|
      t.references :user, null: false, foreign_key: true
      t.string :event_type, null: false
      t.string :title, null: false
      t.text :description
      t.datetime :event_date, null: false
      t.string :url
      t.json :metadata

      t.timestamps
    end

    add_index :external_events, :event_date
    add_index :external_events, :event_type
  end
end
