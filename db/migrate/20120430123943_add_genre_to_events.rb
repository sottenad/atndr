class AddGenreToEvents < ActiveRecord::Migration
  def change
    add_column :events, :genre, :text

  end
end
