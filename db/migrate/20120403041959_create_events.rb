class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text :bands
      t.text :time
      t.text :location
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
