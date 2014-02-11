class AddSchedulingFieldsToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :scheduled_time, :timestamp
    add_column :alerts, :run_every, :integer
  end
end
