class Post < ActiveRecord::Base
  
  # DEPRECATED
  has_many :contents#, after_add: :set_content_flag

  belongs_to :hashtag

  # DEPRECATED
  # Column: tags, assignment: record.tag_list = "foo, bar")
  acts_as_taggable

  # Set pagination default options
  self.per_page = 30

  ### Constant sources array ###
  # SOURCES = %w(vine twitter instagram facebook google_plus tumblr)
  SOURCES = %w(instagram google_plus twitter)

  ### scopes ###
  # create scopes for sources =>
  # => vine_posts, facebook_posts, etc...
  SOURCES.each do |source|
    scope (source + '_posts').to_sym, -> { where(source: source) }
  end

  ### validations ###
  validates :source, inclusion: { in: SOURCES }

  # DEPRECATED
  def has_content?
    !content_ids.empty?
  end

  def profile_display_name
    profile_full_name || profile_username
  end

  def profile_display_url
    case source
    when 'instagram'
      "//instagram.com/#{profile_username}"
    when 'twitter'
      "//twitter.com/#{profile_username}"
    else
      profile_url
    end
  end

  def post_display_url
    case source
    when 'twitter'
      "//twitter.com/#{profile_username}/status/#{api_post_id}"
    else
      post_url
    end
  end

  def posted_at_display
    posted_at.to_formatted_s(:long_ordinal)
  end

  private


end
