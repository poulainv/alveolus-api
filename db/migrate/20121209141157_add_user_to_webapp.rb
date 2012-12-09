class AddUserToWebapp < ActiveRecord::Migration
  def change
     add_column :webapps, :user_id, :integer
  end
end
