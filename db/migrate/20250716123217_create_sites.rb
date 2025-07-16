class CreateSites < ActiveRecord::Migration[8.0]
  def change
    create_table :sites do |t|
      t.string :name, null: false
      t.string :domain, null: false
      t.string :tracking_id, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :sites, :domain, unique: true
    add_index :sites, :tracking_id, unique: true
  end
end
