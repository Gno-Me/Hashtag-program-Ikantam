class RemoveUserIdFromHashtags < ActiveRecord::Migration
  def change
    remove_reference :hashtags, :user
  end
end
