module Social
  module Slaves

    class Social::Slaves::Instagram < Social::Slaves::Base

      def vendor
        'instagram'
      end

      def request

        # deprected, remove when database on porduction will be clean
        query = @hashtag.name.gsub(/\s+/, '')
        
        base_url = "https://api.instagram.com/v1/tags/#{query}/media/recent" + \
        '?access_token=' + Rails.application.secrets.instagram['access_token']


        result = []
        success = true
        min_limit = nil
        outdated = false

        url = base_url

        if @grab.present?
          min_limit = @grab.min_limit
          url += "&min_tag_id=#{@grab.min_limit}"
        end

        while true

          response = Oj.load Faraday.get(url).body

          if response['meta']['code'] != 200
            puts 'ERROR'
            puts response['meta']['error_message']
            success = false
            break
          end

          items = response['data']
          unless items.count > 0
            puts 'NOITEMS'
            break
          end

          if response['pagination']['min_tag_id']

            min_limit = response['pagination']['min_tag_id']

            if @grab.blank?
              @grab = Grab.create(source: vendor, hashtag: @hashtag, min_limit: min_limit)
              success = false
              puts 'relaunch'
              break
            end

          else

            success = false
            break

          end

          items.each do |item|

            published_at = Time.at(item['created_time'].to_i)

            next if published_at < Date.yesterday

            parsed = parse(item)

            if @last_post.present? && @last_post.api_post_id == parsed[:api_post_id]
              outdated = true
              puts 'exists'
              break
            end

            result << parsed
          end

          if outdated
            puts 'OUTDATED'
            break
          end

          unless response['pagination']['min_tag_id']
            puts 'NOPAGE'
            break
          end


          url = base_url + '&min_tag_id=' + min_limit
          
        end

        {
          items: result,
          success: success,
          min_limit: min_limit
        }

      end

      def parse(item)
        parsed = {
          # system info
          source: vendor,
          api_user_id: item['user']['id'],
          api_post_id: item['id'],
          # user info
          profile_username: item['user']['username'],
          profile_full_name: item['user']['full_name'],
          profile_image_url: item['user']['profile_picture'],
          profile_url: nil,
          # post info
          post_description: item['caption'].nil? ? nil : item['caption']['text'],
          posted_at: Time.at(item['created_time'].to_i),
          post_content_type: item['type'],
          post_url: item['link']
        }

        if item['type'] == 'image'
          parsed[:post_content] = item['images']['low_resolution']['url']
        elsif item['type'] == 'video'
          parsed[:post_content] = item['videos']['low_resolution']['url']
        end

        parsed
      end

    end
  end
end