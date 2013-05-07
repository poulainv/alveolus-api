class AddCategoryReferenceToWebapp < ActiveRecord::Migration
  def change
  	add_column :webapps, :category_id, :integer, references: :categories
  end
end
