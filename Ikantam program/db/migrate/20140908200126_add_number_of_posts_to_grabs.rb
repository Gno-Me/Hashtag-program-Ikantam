class AddNumberOfPostsToGrabs < ActiveRecord::Migration
  def change
    add_column :grabs, :number_of_posts, :integer
  end
end
