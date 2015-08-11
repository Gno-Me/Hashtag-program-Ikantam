module Social

  class Social::Master

    def self.slaves
      {
        instagram: Social::Slaves::Instagram,
        google_plus: Social::Slaves::GooglePlus,
        twitter: Social::Slaves::Twitter
      }
    end

    def self.collect_single(grab)
      slave = slaves[grab['source'].to_sym].new(grab)
      slave.collect
    end

  end

end