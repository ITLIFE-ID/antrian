# == Schema Information
#
# Table name: permisi_roles
#
#  id          :bigint           not null, primary key
#  deleted_at  :datetime
#  name        :string           not null
#  permissions :json
#  slug        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_permisi_roles_on_deleted_at  (deleted_at)
#
require "rails_helper"

RSpec.describe PermisiRole, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
