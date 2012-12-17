class AddSocialNetworkId < ActiveRecord::Migration
  def change
    add_column :webapps, :facebook_id, :string
    add_column :webapps, :twitter_id, :string
    add_column :webapps, :gplus_id, :string
  end
end
