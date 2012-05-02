class AddStartdateToEvents < ActiveRecord::Migration
  def change
    add_column :events, :startdate, :datetime

  end
end
