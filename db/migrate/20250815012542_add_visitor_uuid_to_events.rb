class AddVisitorUuidToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :visitor_uuid, :string
    add_index :events, :visitor_uuid
  end
end
