class AddSongsAndPictureToEvents < ActiveRecord::Migration
  def change
    add_column :events, :songs, :text

    add_column :events, :picture, :text

  end
end
