# frozen_string_literal: true

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
class PermisiRole < ApplicationRecord
  validates_presence_of :name, :permissions, :slug
  validates_uniqueness_of :name, :slug
end
