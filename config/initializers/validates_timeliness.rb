ValidatesTimeliness.setup do |config|
  # Extend ORM/ODMs for full support (:active_record).
  config.extend_orms = [ :active_record ]
end
