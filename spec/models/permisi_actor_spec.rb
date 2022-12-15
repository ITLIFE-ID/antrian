# == Schema Information
#
# Table name: permisi_actors
#
#  id         :bigint           not null, primary key
#  aka_type   :string
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  aka_id     :bigint
#
# Indexes
#
#  index_permisi_actors_on_aka                  (aka_type,aka_id)
#  index_permisi_actors_on_aka_type_and_aka_id  (aka_type,aka_id)
#  index_permisi_actors_on_deleted_at           (deleted_at)
#
require "rails_helper"

RSpec.describe PermisiActor, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
