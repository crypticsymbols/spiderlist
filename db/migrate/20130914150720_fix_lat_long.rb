class FixLatLong < ActiveRecord::Migration
  def change
  	add_column :alerts, :long, :string
  	rename_column :alerts, :latlong, :lat
  end
end
