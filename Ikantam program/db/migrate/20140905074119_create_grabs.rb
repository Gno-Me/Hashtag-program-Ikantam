class CreateGrabs < ActiveRecord::Migration
  def change
    create_table :grabs do |t|

      t.string :source
      t.string :min_limit

      t.references :hashtag

      t.timestamps
    end
  end
end
