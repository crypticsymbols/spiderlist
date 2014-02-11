class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.references :alert, index: true
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
