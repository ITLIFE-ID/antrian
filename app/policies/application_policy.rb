# frozen_string_literal: true

# Base class for application policies
class ApplicationPolicy < ActionPolicy::Base
  # Configure additional authorization contexts here
  # (`user` is added by default).
  #
  #   authorize :account, optional: true
  #
  # Read more about authorization context: https://actionpolicy.evilmartians.io/#/authorization_context

  # Define shared methods useful for most policies.
  # For example:
  #

  def new
    admin?
  end

  def index
    admin?
  end

  def create
    admin?
  end

  def edit
    admin?
  end

  def update
    admin?
  end

  def destroy
    admin?
  end

  relation_scope do |relation|
    next relation if super_admin?
    relation.where(company: user.company)
  end

  scope_for :field_authorization do |resource, required_options|
    attribute = required_options[:attribute]&.attribute || required_options[:field]
    klass_for_super_admin_only = [Building, Service, SatisfactionIndex, User, Administrator]

    next false if user.id == 1

    resource_validation = if required_options.key? :field
      klass_for_super_admin_only.include? resource
    else
      klass_for_super_admin_only.select { |klass| resource.is_a?(klass) }.any?
    end

    attribute == :company && resource_validation
  end

  scope_for :relation do |relation, association|
    next relation if super_admin?
    relation.send(association)
  end

  def owner?
    record.id == user.id
  end

  def admin?
    user.is_a? Administrator
  end

  def super_admin?
    user.id == 1
  end
end
