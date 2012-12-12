class AddVideoUrlTuWebapps < ActiveRecord::Migration
  def change
     add_column :webapps, :video_url, :string
  end
end
