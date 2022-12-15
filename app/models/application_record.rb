# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  acts_as_paranoid
  has_paper_trail
end
