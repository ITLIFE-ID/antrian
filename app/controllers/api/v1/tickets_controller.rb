# frozen_string_literal: true

module Api
  module V1
    class TicketsController < Api::V1::BaseController
      def create
        result = PrintTicketService.execute(permitted_params)

        return render jsonapi_errors: result.errros, status: 422 unless result.success?

        head 200
      end
    end
  end
end
