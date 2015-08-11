class SocialCollectWorker
  # comment "include Sidekiq::Worker" for debug
  include Sidekiq::Worker

  def perform(grab)
    Social::Master.collect_single(grab)
  end
end