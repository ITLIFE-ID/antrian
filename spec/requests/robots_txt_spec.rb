# frozen_string_literal: true

require "rails_helper"

# describe 'robots.txt' do
#   context 'when not blocking all web crawlers' do
#     it 'allows all crawlers' do
#       get '/robots.txt'

#       expect(response.code).to eq '404'
#       expect(response.headers['X-Robots-Tag'].nil?).to be(true)
#     end
#   end

#   context 'when blocking all web crawlers' do
#     it 'blocks all crawlers' do
#       # Stub ENV to produce ENV["DISALLOW_ALL_WEB_CRAWLERS"] == "true"
#       allow(ENV).to receive(:[]).and_call_original
#       allow(ENV).to receive(:[]).with('DISALLOW_ALL_WEB_CRAWLERS').and_return('true')

#       get '/robots.txt'
#       expect(response.body).to eq "User-agent: *\nDisallow: /"
#       expect(response.headers['X-Robots-Tag']).to eq 'none'
#     end
#   end
# end
