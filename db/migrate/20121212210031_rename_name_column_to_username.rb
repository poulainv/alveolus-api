class RenameNameColumnToUsername < ActiveRecord::Migration
  def up
    rename_column :webapps, :video_url, :vimeo_id
  end

  def down
     rename_column :webapps, :video_url,:vimeo_id
  end
end
