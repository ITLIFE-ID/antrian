# frozen_string_literal: true

# == Schema Information
#
# Table name: company_working_days
#
#  id           :bigint           not null, primary key
#  closing_time :time
#  day          :integer
#  deleted_at   :datetime
#  open_time    :time
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :bigint
#
# Indexes
#
#  index_company_working_days_on_company_id          (company_id)
#  index_company_working_days_on_day_and_company_id  (day,company_id) UNIQUE
#  index_company_working_days_on_deleted_at          (deleted_at)
#
class CompanyWorkingDay < ApplicationRecord
  belongs_to :company

  validates_datetime :open_time, before: :closing_time
  validates_datetime :closing_time, after: :open_time

  validates_uniqueness_of :day, scope: :company_id

  validates_numericality_of :day, only_integer: true, greater_than_or_equal_to: 1,
    less_than_or_equal_to: 7
end
