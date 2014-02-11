class ZipcodesToVarcahar < ActiveRecord::Migration
  def change
  	# remove_column :alerts, :zipcode
  	add_column :alerts, :zipcode, :string, :limit => 20
  end
end
