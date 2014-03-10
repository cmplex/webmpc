class RemoveAlbumFromSongs < ActiveRecord::Migration
  def change
	remove_column :songs, :album, :string
  end
end
