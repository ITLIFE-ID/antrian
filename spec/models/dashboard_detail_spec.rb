# == Schema Information
#
# Table name: dashboard_details
#
#  id           :bigint           not null, primary key
#  date         :date
#  deleted_at   :datetime
#  total        :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :bigint
#  dashboard_id :bigint
#
# Indexes
#
#  index_dashboard_details_on_company_id    (company_id)
#  index_dashboard_details_on_dashboard_id  (dashboard_id)
#  index_dashboard_details_on_deleted_at    (deleted_at)
#
require "rails_helper"

RSpec.describe DashboardDetail, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
