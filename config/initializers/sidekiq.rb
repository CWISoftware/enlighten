# not defined for :test environment
if defined? Sidekiq
  Sidekiq.configure_server do |config|
    config.redis = { url: 'redis://localhost:6379' }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: 'redis://localhost:6379' }
  end
end
