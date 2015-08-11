module Social
  module Slaves

    class Social::Slaves::Twitter < Social::Slaves::Base

      def vendor
        'twitter'
      end

      def request

        # deprected, remove when database on porduction will be clean
        query = @hashtag.name.gsub(/\s+/, '')

        # '-rt' without retweets
        base_url = '#' + query + ' -rt'
        base_options = {}

        twitter_secrets = Rails.application.secrets.twitter
        client = ::Twitter::REST::Client.new do |config|
          config.consumer_key = twitter_secrets['consumer']['key']
          config.consumer_secret = twitter_secrets['consumer']['secret']
          config.access_token = twitter_secrets['access']['key']
          config.access_token_secret = twitter_secrets['access']['secret']
        end

        result = []
        success = true
        min_limit = nil
        outdated = false

        options = base_options

        if @grab.present?
          min_limit = @grab.min_limit
          options[:since_id] = min_limit
        end

        while true

          response = client.search(base_url, options).to_h

          if response[:errors]
            puts 'ERROR'
            puts response[:errors].inspect
            success = false
            break
          end

          items = response[:statuses]
          unless items.count > 0
            puts 'NOITEMS'
            break
          end

          if response[:search_metadata][:max_id]

            min_limit = response[:search_metadata][:max_id]

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

            published_at = item[:created_at].to_datetime
            
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

          unless response[:search_metadata][:max_id]
            puts 'NOPAGE'
            break
          end

          options[:since_id] = min_limit

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
          api_user_id: item[:user][:id_str],
          api_post_id: item[:id_str],
          # user info
          profile_username: item[:user][:screen_name],
          profile_full_name: item[:user][:name],
          profile_image_url: item[:user][:profile_image_url],
          profile_url: nil,
          # post info
          post_description: item[:text],
          posted_at: item[:created_at].to_datetime,
          post_content_type: nil,
          post_url: nil
        }

        media = item[:entities][:media]
        if media && media.count > 0
          media_item = media.first
          if media_item[:type] == 'photo'
            parsed[:post_content_type] = 'image'
            parsed[:post_content] = media_item[:media_url]
          end
        end

        parsed
      end

    end

  end
end
