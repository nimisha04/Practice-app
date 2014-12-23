class AddImageUrlToTwitterUsers < ActiveRecord::Migration
  def change
    add_column :twitter_users, :image_url, :text
  end
end
