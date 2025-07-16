class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.references :site, null: false, foreign_key: true
      t.string :event_name, null: false
      t.json :properties
      t.string :page_url
      t.string :referrer
      t.string :user_agent
      t.string :ip_address
      t.boolean :is_bot, default: false

      t.datetime :created_at, null: false
    end

    add_index :events, :event_name
    add_index :events, :is_bot
    add_index :events, :created_at
  end
end
