class AddAccessTokenToAuthentication < ActiveRecord::Migration
  def change
    add_column :authentications, :access_token, :string
  end
end
