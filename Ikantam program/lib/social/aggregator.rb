module Social

  class Social::Aggregator

    def self.collect

      Hashtag.all.each do |hashtag|
        hashtag.update_grab_sources
      end

      @grabs = Grab.to_collect
      @grabs.each do |grab|
        self.process(grab)
      end
    end

    def self.process(grab)
      # use for debug
      # SocialCollectWorker.new.perform(grab)
      
      # use for production
      SocialCollectWorker.perform_async(grab)
    end

  end
  
end