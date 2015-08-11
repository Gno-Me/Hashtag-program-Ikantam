class ChangePostedAtFromDateToDateTimeInPosts < ActiveRecord::Migration

  def up
    change_column :posts, :posted_at, :datetime
  end

  def down
    change_column :posts, :posted_at, :datetime
  end
end
