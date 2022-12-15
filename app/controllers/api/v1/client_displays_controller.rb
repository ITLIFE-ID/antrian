# frozen_string_literal: true

module Api
  module V1
    class ClientDisplaysController < Api::V1::BaseController
      before_action :set_client_display

      def preload
        playlist = PlayList.where(client_display: @client_display)
      end

      private 
      def set_client_display
        @client_display ||= ClientDisplay.find(params[:id])
      end
    end
  end
end
