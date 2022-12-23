# frozen_string_literal: true

# == Schema Information
#
# Table name: services
#
#  id              :bigint           not null, primary key
#  active          :boolean          default(TRUE)
#  closing_time    :datetime
#  deleted_at      :datetime
#  letter          :string
#  name            :string
#  open_time       :datetime
#  priority        :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  company_id      :bigint
#  parent_id       :bigint           default(0)
#  service_type_id :bigint
#
# Indexes
#
#  index_services_on_company_id       (company_id)
#  index_services_on_deleted_at       (deleted_at)
#  index_services_on_parent_id        (parent_id)
#  index_services_on_service_type_id  (service_type_id)
#
FactoryBot.define do
  factory :service do
    association :company
    association :service_type

    active { [true, false].sample }
    letter { ("A".."Z").to_a.sample }
    name { "Pendaftaran" }
    priority { [true, false].sample }
    max_quota { rand(10..100) }
    closed { false }
    max_service_time { 3600 }
  end
end
