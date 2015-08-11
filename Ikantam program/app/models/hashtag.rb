class Hashtag < ActiveRecord::Base

  has_many :posts
  has_many :grabs
  has_and_belongs_to_many :users

  # hashtag validation - http://stackoverflow.com/a/12102931/1573638
  validates :name,
    presence: true,
    length: { maximum: 250 },
    uniqueness: { case_sensitive: true, message: 'already exists' },
    format: {
      with: /\A[_a-zA-Z0-9]+\z/,
      message: 'valid hashtag should contain only letters, numbers or underscores'
    }

  def update_grab_sources
    missing_sources = Post::SOURCES - grabs.pluck(:source)
    missing_sources.each do |missing_source|
      grabs << Grab.create(source: missing_source)
    end
  end

  def latest_posts
    posts.order('posted_at DESC')
  end

end