class AddNewColumnToMyTable < ActiveRecord::Migration
  def change
     add_column :webapps, :promoted, :boolean
  end
end
