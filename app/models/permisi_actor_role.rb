# frozen_string_literal: true

# == Schema Information
#
# Table name: permisi_actor_roles
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  actor_id   :bigint
#  role_id    :bigint
#
# Indexes
#
#  index_permisi_actor_roles_on_actor_id              (actor_id)
#  index_permisi_actor_roles_on_actor_id_and_role_id  (actor_id,role_id) UNIQUE
#  index_permisi_actor_roles_on_deleted_at            (deleted_at)
#  index_permisi_actor_roles_on_role_id               (role_id)
#
class PermisiActorRole < ApplicationRecord
  belongs_to :administrator
  belongs_to :permisi_role
end
