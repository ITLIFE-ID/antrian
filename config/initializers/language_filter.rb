# frozen_string_literal: true

matchlist_files = Dir["#{Rails.root.join("config/language_filters/matchlists")}/*.yml"]

execptionlist_files = Dir["#{Rails.root.join("config/language_filters/execptionlist")}/*.yml"]

sex = LanguageFilter::Filter.new matchlist: :sex # sex words from gem
hate = LanguageFilter::Filter.new matchlist: :hate # hate words from gem
violence = LanguageFilter::Filter.new matchlist: :violence # violence words from gem
profanity = LanguageFilter::Filter.new matchlist: :profanity # profanity words from gem

exceptionlists = []
matchlists = []

matchlists << sex.matchlist
matchlists << hate.matchlist
matchlists << violence.matchlist
matchlists << profanity.matchlist

exceptionlists << sex.exceptionlist
exceptionlists << hate.exceptionlist
exceptionlists << violence.exceptionlist
exceptionlists << profanity.exceptionlist

matchlist_files.each do |matchlist_file|
  matchlist_datas = YAML.load_file(matchlist_file)

  matchlists << matchlist_datas if matchlist_datas.present?
end

execptionlist_files.each do |execptionlist_file|
  execptionlist_datas = YAML.load_file(execptionlist_file)

  exceptionlists << execptionlist_datas if execptionlist_datas.present?
end

Rails.configuration.language_filter_matchlists = matchlists.flatten

Rails.configuration.language_filter_exceptionlists = exceptionlists.flatten
