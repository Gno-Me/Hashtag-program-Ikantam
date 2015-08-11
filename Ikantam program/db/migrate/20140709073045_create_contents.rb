class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.belongs_to :post
      t.integer :type
      t.string :url
      t.timestamps
    end
  end
end