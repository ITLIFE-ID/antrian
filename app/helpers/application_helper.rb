# frozen_string_literal: true

module ApplicationHelper
  def days_of_week
    days = Date::DAYNAMES.rotate(1)
    days.while_loop.map { |value, index| {(index + 1).to_s => value} }.reduce({}, :merge)
  end
end
