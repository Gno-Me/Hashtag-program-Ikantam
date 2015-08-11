class AddGrabbedAtToHashtags < ActiveRecord::Migration
  def change
    add_column :hashtags, :grabbed_at, :datetime
  end
end
