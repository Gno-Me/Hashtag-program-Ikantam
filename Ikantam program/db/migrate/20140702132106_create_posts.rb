class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :source
      t.string :username
      t.text :description
      t.string :api_user_id
      t.string :api_post_id
      t.date :posted_at

      t.timestamps
    end
  end
end
