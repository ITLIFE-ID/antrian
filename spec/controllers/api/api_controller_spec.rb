# frozen_string_literal: true

require "rails_helper"

# RSpec.describe Api::ApiController do
# describe '#api_error_response' do
#   context 'with all params filled' do
#     it 'return correct jsonapi error format' do
#       error_response = controller.api_error_response('400', 'Bad request',
#                                                      'This is an error message', :blank)
#       expect(error_response).to eq({
#                                      errors: [{
#                                        status: '400',
#                                        title:  'Bad request',
#                                        detail: 'This is an error message',
#                                        code:   :blank
#                                      }]
#                                    })
#     end
#   end

#   context 'without filled any params' do
#     it 'return correct jsonapi error format but all of them empty' do
#       error_response = controller.api_error_response
#       expect(error_response).to eq({ errors: [{ status: '', title: '', detail: '', code: '' }] })
#     end
#   end
# end
# end
