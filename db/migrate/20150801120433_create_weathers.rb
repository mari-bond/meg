class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.string :city
      t.string :country
      t.string :description
      t.float :temp
      t.float :pressure
      t.float :humidity
      t.float :wind

      t.timestamps
    end
  end
end
