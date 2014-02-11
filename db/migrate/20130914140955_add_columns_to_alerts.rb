class AddColumnsToAlerts < ActiveRecord::Migration
  def change
  	add_column :alerts, :category, :string
  	# add_column :alerts, :zipcode, :integer
  	add_column :alerts, :latlong, :string
  	add_column :alerts, :radius, :integer
  	add_column :alerts, :terms, :text
  	add_column :alerts, :price_min, :integer
  	add_column :alerts, :price_max, :integer
  end
end
