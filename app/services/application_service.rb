# frozen_string_literal: true

class ApplicationService
  extend ActiveModel::Naming
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations
  include MqttHelper

  attr_accessor :errors

  def self.execute(attributes = {})
    service_instance = new(attributes)
    service_instance.execute
    service_instance
  end

  def initialize(attributes = {})
    @errors = ActiveModel::Errors.new(self)
    assign_attributes(attributes)
  end

  def failed?
    errors.any?
  end

  def success?
    !failed?
  end
end
