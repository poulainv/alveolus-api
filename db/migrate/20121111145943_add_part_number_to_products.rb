class AddPartNumberToProducts < ActiveRecord::Migration
  def change
    add_column :webapps, :max_users, :integer, :default => 10
  end
end
