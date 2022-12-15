# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      include ApplicationHelper

      include JSONAPI::Pagination
      include JSONAPI::Filtering
      include JSONAPI::Fetching
      include JSONAPI::Deserialization
      include JSONAPI::Errors

      DEFAULT_PAGE_SIZE = 10
      MAX_PAGE_SIZE = 30
      ALLOWED_INCLUDE_LIST = [].freeze

      skip_before_action :verify_authenticity_token

      after_action -> { request.session_options[:skip] = true }

      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      private

      def not_found
        render(
          json: api_error_response("404", "Not found", "Not found", :not_found),
          status: :not_found
        )
      end

      def include_params
        params[:include].present? ? params[:include] : ""
      end

      def allowed_include
        arr = include_params.split(",")
        arr.select { |a| a.in? self.class::ALLOWED_INCLUDE_LIST }
      end

      def jsonapi_serializer_params
        return {} if allowed_include.blank?

        {includes: allowed_include}
      end

      def jsonapi_include
        super & self.class::ALLOWED_INCLUDE_LIST
      end

      def jsonapi_meta(resources)
        pagination = jsonapi_pagination_meta(resources)

        return unless pagination.present?

        {
          pagination: pagination,
          current_page_size: @per_page,
          max_page_size: MAX_PAGE_SIZE
        }
      end

      def jsonapi_page_size(_pagination_params)
        @per_page = params[:size].present? ? params[:size].to_i : DEFAULT_PAGE_SIZE
        @per_page = MAX_PAGE_SIZE if @per_page > MAX_PAGE_SIZE
        @per_page
      end

      def render_jsonapi_internal_server_error(exception)
        raise exception if Rails.env.development?

        Sentry.capture_exception(exception)
        super(exception)
      end
    end
  end
end
