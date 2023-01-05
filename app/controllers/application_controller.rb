# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_paper_trail_whodunnit

  protected

  def permitted_params
    params.permit(:id, :print_ticket_location, :date, :service_id, :counter_id, :attend, :transfer, :uuid)
  end
end
