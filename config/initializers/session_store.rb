ActionDispatch::Session::ActiveRecordStore.session_class = ActiveRecord::SessionStore::CustomSession

if ENV["REDIS_URL"].present?
  Rails.application.config.session_store :redis_store, servers: ["#{ENV["REDIS_URL"]}/0/queue_system_#{Rails.env}_session"], expire_after: 24.hours    
end
