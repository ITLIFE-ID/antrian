require "administrate/custom_dashboard"

module Admin
  class DigitalReceiptsController < Admin::ApplicationController
    layout "digital_receipt"

    def index
      @queue = TodayQueue.find_by(uniq_number: permitted_params["uniq_number"])
    end

    private 
    def permitted_params
      params.permit(:uniq_number)
    end
  end
end