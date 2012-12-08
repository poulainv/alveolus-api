class AddNbClickSharedToWebapps < ActiveRecord::Migration
  def change
    add_column :webapps, :nb_click_shared, :integer
  end
end
