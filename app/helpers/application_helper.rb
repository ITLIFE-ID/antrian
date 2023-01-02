# frozen_string_literal: true

module ApplicationHelper
  def days_of_week
    days = Date::DAYNAMES.rotate(1)
    days.each_with_index.map { |value, index| {(index + 1).to_s => value} }.reduce({}, :merge)
  end

  def self.queue_number_formater(letter, number)
    "#{letter || "Z"} #{number&.to_s&.rjust(3, "0") || "000"}"
  end
end
