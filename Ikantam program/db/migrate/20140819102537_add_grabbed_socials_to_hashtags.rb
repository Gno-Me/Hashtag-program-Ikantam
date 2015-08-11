class AddGrabbedSocialsToHashtags < ActiveRecord::Migration
  def change
    add_column :hashtags, :grabbed_socials, :string
  end
end
