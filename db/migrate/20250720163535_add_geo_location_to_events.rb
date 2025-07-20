class AddGeoLocationToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :country, :string
    add_column :events, :city, :string
    add_column :events, :region, :string
  end
end
