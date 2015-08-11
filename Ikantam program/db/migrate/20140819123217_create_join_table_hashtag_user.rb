class CreateJoinTableHashtagUser < ActiveRecord::Migration
  def change
    create_join_table :hashtags, :users do |t|
      # t.index [:hashtag_id, :user_id]
      # t.index [:user_id, :hashtag_id]
    end
  end
end
