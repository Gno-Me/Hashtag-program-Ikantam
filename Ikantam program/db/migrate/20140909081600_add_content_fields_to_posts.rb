class AddContentFieldsToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.rename :username, :profile_username
      t.string :profile_full_name
      t.string :profile_image_url
      t.string :profile_url
      t.rename :description, :post_description
      t.string :post_content_type
      t.string :post_content
      t.string :post_url
    end
  end
end
