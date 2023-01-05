class DigitalReceiptsController < ApplicationController
  layout "digital_receipt"

  def index
    @queue = TodayQueue.find_by(uniq_number: permitted_params["uuid"])
  end
end