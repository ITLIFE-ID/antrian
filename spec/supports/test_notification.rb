# frozen_string_literal: true

class TestNotification < Noticed::Base
  deliver_by :database

  def message
    params[:message]
  end
end
