class RemoveQueryColumnFromAlerts < ActiveRecord::Migration
  def change
  	remove_column :alerts, :query
  end
end
