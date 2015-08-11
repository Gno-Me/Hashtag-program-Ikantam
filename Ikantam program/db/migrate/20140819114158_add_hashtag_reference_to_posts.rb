class AddHashtagReferenceToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :hashtag, index: true
  end
end
