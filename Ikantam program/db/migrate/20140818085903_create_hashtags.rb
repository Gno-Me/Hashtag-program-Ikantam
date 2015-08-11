class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.string :name, null: false
      t.integer :count, null: false, default: 0
      t.boolean :is_deleted, null: false, default: false

      t.references :user, null: false, index: true
    end
  end
end
