Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redisdb:6379/0' }
end
 
Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redisdb:6379/0' }
end