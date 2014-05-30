class FixColumnName < ActiveRecord::Migration
  def change
      rename_column :posts, :url, :storyurl
  end
end
