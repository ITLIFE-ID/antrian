# frozen_string_literal: true

# == Schema Information
#
# Table name: company_closing_days
#
#  id          :bigint           not null, primary key
#  date        :date
#  deleted_at  :datetime
#  finish_time :datetime
#  start_time  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :bigint
#
# Indexes
#
#  index_company_closing_days_on_company_id           (company_id)
#  index_company_closing_days_on_date_and_company_id  (date,company_id) UNIQUE
#  index_company_closing_days_on_deleted_at           (deleted_at)
#
class CompanyClosingDay < ApplicationRecord
  belongs_to :company

  validates_date :date, on_or_after: :today
  validates_datetime :start_time, before: :finish_time
  validates_datetime :finish_time, after: :start_time

  validates_uniqueness_of :date, scope: :company_id
  validates_presence_of :date, :finish_time, :start_time
end
