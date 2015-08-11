=begin
class Social::Slaves::Vine
  # include Social::Slave
  include HTTParty
  base_uri 'https://api.vineapp.com'


  def initialize
    @scope = :vine_posts
  end

  private

  def tag_request(tag, page = 1)
    self.class.get("/timelines/tags/#{tag}?page=#{page}")
  end

  def parse(response)
    records = response['data']['records']
    records.map do |record|
      {
        source: 'vine',
        username: record['username'],
        description: record['description'],
        api_user_id: record['userId'].to_s, # use strings for bigint ids
        api_post_id: record['postId'].to_s,
        posted_at: record['created'],
        tag_list: record['entities'].map{ |entity| entity['title'] }.join(', ')
      }
    end
  end

end
=end