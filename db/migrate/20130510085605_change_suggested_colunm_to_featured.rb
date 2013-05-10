class ChangeSuggestedColunmToFeatured < ActiveRecord::Migration
  def change
    rename_column :webapps, :suggested, :featured
  end
end
