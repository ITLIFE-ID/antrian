# frozen_string_literal: true

# == Schema Information
#
# Table name: shared_clientdisplays
#
#  id                      :bigint           not null, primary key
#  clientdisplay_able_type :string
#  deleted_at              :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  client_display_id       :bigint
#  clientdisplay_able_id   :bigint
#
# Indexes
#
#  index_shared_clientdisplays_on_client_display      (clientdisplay_able_id,clientdisplay_able_type) UNIQUE
#  index_shared_clientdisplays_on_client_display_id   (client_display_id)
#  index_shared_clientdisplays_on_clientdisplay_able  (clientdisplay_able_type,clientdisplay_able_id)
#  index_shared_clientdisplays_on_deleted_at          (deleted_at)
#
class SharedClientdisplay < ApplicationRecord
  belongs_to :clientdisplay_able, polymorphic: true
  belongs_to :client_display

  validates_uniqueness_of :client_display_id, scope: [:clientdisplay_able_id, :clientdisplay_able_type]
end
