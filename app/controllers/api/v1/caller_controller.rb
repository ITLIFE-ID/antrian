# frozen_string_literal: true

module Api
  module V1
    class CallerController < Api::V1::BaseController
      def call
        result = Caller::CallService.execute(permitted_params)

        return render jsonapi_errors: result.errros, status: 422 unless result.success?

        head 200
      end

      def recall
        result = Caller::RecallService.execute(permitted_params)

        return render jsonapi_errors: result.errros, status: 422 unless result.success?

        head 200
      end

      def transfer
        result = Caller::RecallService.execute(permitted_params)

        return render jsonapi_errors: result.errros, status: 422 unless result.success?

        head 200
      end

      def activate_queue
        result = Caller::ActivateQueueService.execute(permitted_params)

        return render jsonapi_errors: result.errros, status: 422 unless result.success?

        head 200
      end
    end
  end
end
