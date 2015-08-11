require 'nokogiri'

module Social
  module Slaves

    class Social::Slaves::GooglePlus < Social::Slaves::Base

      def vendor
        'google_plus'
      end

      def request

        # deprected, remove when database on porduction will be clean
        query = @hashtag.name.gsub(/\s+/, '')

        base_url = "https://www.googleapis.com/plus/v1/activities?query=%23#{query}" + \
            '&key=' + Rails.application.secrets.google_plus['app_access_token'] + '&maxResults=20'
        url = base_url

        result = []
        outdated = false
        success = true

        while true

          response = Oj.load Faraday.get(url).body

          if response['error']
            puts 'ERROR'
            puts response['error'].inspect
            success = false
            break
          end

          items = response['items']
          unless items.count > 0
            puts 'NOITEMS'
            break
          end

          if @grab.blank?
            @grab = Grab.create(source: vendor, hashtag: @hashtag)
            success = false
            puts 'relaunch'
            break
          end

          items.each do |item|

            published_at = item['published'].to_datetime

            if published_at < Date.yesterday
              outdated = true
              next
            end

            # check whether post exists
            parsed = parse(item)

            if @last_post.present? && @last_post.api_post_id == parsed[:api_post_id]
              outdated = true
              puts 'exists'
              next
            end

            result << parsed
          end

          if outdated
            puts 'OUTDATED'
            break
          end

          unless response['nextPageToken']
            puts 'NOPAGE'
            break
          end

          url = base_url + '&pageToken=' + response['nextPageToken']

        end
        
        {
          items: result,
          success: success
        }
      end

      def parse(item)
        parsed_tree = Nokogiri::HTML(item['object']['content'])
        parsed = {
          # system info
          source: vendor,
          api_user_id: item['actor']['id'],
          api_post_id: item['id'],
          # user info
          profile_username: item['actor']['displayName'],
          profile_full_name: nil,
          profile_image_url: item['actor']['image']['url'],
          profile_url: item['actor']['url'],
          # post info
          post_description: parsed_tree.content,
          posted_at: item['updated'],
          post_content_type: item['object']['objectType'],
          post_url: item['url']
        }
        parsed
      end

    end

  end
end