JsRoutes.setup do |config|
  config.prefix = Rails.application.secrets.url_prefix
end