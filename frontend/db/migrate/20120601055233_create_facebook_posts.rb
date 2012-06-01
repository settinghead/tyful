class CreateFacebookPosts < ActiveRecord::Migration
  def self.up
    create_table :facebook_posts do |t|
      t.string :fbid
      t.text :message
      t.datetime :time_posted
      t.string :link
      t.string :type
      t.string :category
      t.timestamps
    end
  end

  def self.down
    drop_table :facebook_posts
  end
end
