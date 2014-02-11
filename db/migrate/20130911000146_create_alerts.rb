class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.text :query
      t.references :user, index: true

      t.timestamps
    end
  end
end
