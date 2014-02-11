class AddTimeZoneToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :time_zone, :string, :limit => 140
  end
end
