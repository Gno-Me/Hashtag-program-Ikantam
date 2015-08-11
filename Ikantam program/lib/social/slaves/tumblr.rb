=begin
class Social::Slaves::Tumblr
  # include Social::Slave
  def initialize
    @scope = :tumblr_posts
  end

  private

  def tag_request(query, timestamp = nil)
    request = "https://api.tumblr.com/v2/tagged?tag=#{query}&filter=text" + \
    '&api_key=' + Rails.application.secrets.tumblr['consumer']['key']
    unless timestamp.nil?
      request += '&before=' + timestamp.to_s
    end
    response = Oj.load Faraday.get(request).body
    response['response']
  end

  def parse(response)
    # TODO: ужасный код, поправить
    response.map do |record|
      data = {
        source: 'tumblr',
        username: record['blog_name'],
        api_user_id: record['slug'],
        api_post_id: record['id'].to_s,
        posted_at: record['date'],
        tag_list: record['tags'].join(', ')
      }
      data[:description] = case record['type']
        when 'photo' then record['caption']
        when 'answer' then "Q: #{record['question']}\n\nA: #{record['answer']}"
        when 'text' then record['body']
      end
      data
    end
  end

end
=end