# == Schema Information
#
# Table name: dashboards
#
#  id         :bigint           not null, primary key
#  name       :string
#  total      :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Dashboard, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
