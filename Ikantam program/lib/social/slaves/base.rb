module Social
  module Slaves

    class Social::Slaves::Base

      def initialize(grab)

        @grab = Grab.find_by_id(grab['id'])

        @hashtag = @grab.hashtag

        @last_post = @hashtag.posts.send(scope).last
      end

      def collect
        unless @hashtag.present?
          puts 'no hashtag present'
          return
        end

        before_collect

        result = request

        if result[:success] == true

          if result[:items].any?
            save(result[:items])
          end

          grab_attributes = {
            number_of_posts: Post.send(scope).where(hashtag: @hashtag).count
          }
          if result.has_key?(:min_limit)
            grab_attributes[:min_limit] = result[:min_limit]
          end
          @grab.update_attributes(grab_attributes) 
          @grab.touch

          after_collect
        else

          puts 'Was not collected'

        end

      end

      def save(items)
        items.each do |item|

          # check if post exists in current social network with the same id
          post = Post.send(scope).find_or_initialize_by(api_post_id: item[:api_post_id])

          # add hashtag relationship
          item[:hashtag] = @hashtag

          post.update_attributes(item)
        end
      end

      private

      def vendor
        raise 'method "vendor" should be overriden'
      end

      def scope
        (vendor + '_posts').to_sym
      end

      def before_collect
      end

      def after_collect
      end

    end

  end
end