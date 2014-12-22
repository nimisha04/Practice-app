class AddTwitterProviderToUser < ActiveRecord::Migration
  def change
  	add_column :users, :twitter_provider, :string
    add_column :users, :twitter_uid, :string
  end
end
