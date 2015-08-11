class Grab < ActiveRecord::Base
  belongs_to :hashtag

  def self.to_collect
    order('updated_at ASC').limit(1)
  end
end