class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :text
      t.boolean :is_readed, default: false
      t.time :date_reading
      t.integer :user_id
      t.string :path_action
      t.timestamps 
    end
  end
end
