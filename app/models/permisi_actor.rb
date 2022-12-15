# frozen_string_literal: true

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
class PermisiActor < ApplicationRecord
end
