# frozen_string_literal: true

# Base class for application policies
class ApplicationPolicy < ActionPolicy::Base
  pre_check :allow_admins
  # Configure additional authorization contexts here
  # (`user` is added by default).
  #
  #   authorize :account, optional: true
  #
  # Read more about authorization context: https://actionpolicy.evilmartians.io/#/authorization_context

  # Define shared methods useful for most policies.
  # For example:
  #

  scope_for :authorized_klass do |relation|
    next relation if super_admin?
    next relation if relation.first.instance_of?(Company)

    if scoped_model.include? relation
      user.company.send(relation.to_s.downcase.pluralize)
    end
  end

  scope_for :authorized_resource do |relation|
    next relation if super_admin?
    next relation if relation.first.instance_of?(Company)

    if scoped_model.include? relation
      relation.where(company: user.company)
    end
  end

  scope_for :field_authorization do |resource, required_options|
    attribute = required_options[:attribute]&.attribute || required_options[:field]

    next false if super_admin?

    resource_validation = if required_options.key? :field
      scoped_model.include? resource
    else
      scoped_model.select { |klass| resource.is_a?(klass) }.any?
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

  def allow_admins
    allow! if admin?
  end

  def allow_super_admins
    allow! if admin? && super_admin?
  end

  def scoped_model
    [Building, Service, SatisfactionIndex, User, Administrator, ServiceType]
  end
end
