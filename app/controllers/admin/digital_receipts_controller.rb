require "administrate/custom_dashboard"
module Admin
  class DigitalReceiptsController < Admin::ApplicationController
    layout false

    before_action :generate_qrcode

    def index
      @queue = TodayQueue.find_by(unique_number: permitted_params["unique_number"])
      render pdf: "index", page_size: "A8", margin:  {top: 1, bottom: 1, left: 1, right: 1}
    end

    private 
    def permitted_params
      params.permit(:unique_number)
    end

    def generate_qrcode
      png = RQRCode::QRCode.new(permitted_params["unique_number"]).as_png(
        bit_depth: 1,
        border_modules: 4,
        color_mode: ChunkyPNG::COLOR_GRAYSCALE,
        color: "black",
        file: nil,
        fill: "white",
        module_px_size: 6,
        resize_exactly_to: false,
        resize_gte_to: false,
        size: 120
      )

      @qrcode = IO.binwrite("/tmp/qrcode_queue_number_#{permitted_params["unique_number"]}.png", png.to_s)      
    end
  end
end