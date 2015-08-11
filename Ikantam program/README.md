Matt Pound GnoMe
===========================

### Deploy (Manually)

Go to Ikantam AWS, project is under `/var/rails_apps/matt_pound`

* `git pull origin master`
* `bundle install`
* `RAILS_ENV=production bundle exec rake db:migrate`
* `RAILS_ENV=production bundle exec rake assets:precompile RAILS_RELATIVE_URL_ROOT='/matt_pound'`
* `touch tmp/restart.txt`

### Queue manager (Sidekiq) on the server

* as daemon - `sidekiq -d -e production -L log/sidekiq.log`
* to debug without queue manager follow comments in `app/workers/social_collect_worker.rb:2` and `lib/social/aggregator.rb:18`

### TODO

* nice logging for slaves
* foreigner
* filter
* parse media
