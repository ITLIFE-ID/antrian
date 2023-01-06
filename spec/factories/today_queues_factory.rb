# frozen_string_literal: true

# == Schema Information
#
# Table name: today_queues
#
#  id                    :bigint           not null, primary key
#  active                :boolean          default(FALSE)
#  attend                :boolean          default(FALSE)
#  date                  :date
#  deleted_at            :datetime
#  finish_time           :datetime
#  letter                :string
#  note                  :string
#  number                :integer
#  print_ticket_location :string
#  print_ticket_method   :string
#  print_ticket_time     :datetime
#  priority              :boolean          default(FALSE)
#  service_type_slug     :string
#  start_time            :datetime
#  uniq_number           :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  counter_id            :bigint
#  parent_id             :bigint
#  service_id            :bigint
#
# Indexes
#
#  index_today_queues_on_counter_id  (counter_id)
#  index_today_queues_on_deleted_at  (deleted_at)
#  index_today_queues_on_parent_id   (parent_id)
#  index_today_queues_on_service_id  (service_id)
#
FactoryBot.define do
  factory :today_queue do
    trait :new_queue do
      association :service
      service_type_slug { service.service_type.slug }
      uniq_number { SecureRandom.uuid }
      priority { false }
      print_ticket_time { DateTime.current.change({hour: 9, min: 0, sec: 0}) }
      letter { service.letter }
      date { Time.current }
      number { rand(1..100) }
    end

    trait :already_called do
      association :counter
      start_time { DateTime.current.change({hour: 10, min: 0, sec: 0}) }
      finish_time { DateTime.current.change({hour: 11, min: 0, sec: 0}) }
    end

    trait :online do
      print_ticket_location { "mobile" }
      print_ticket_method { "online" }
    end

    trait :offline do
      print_ticket_location { "kiosk" }
      print_ticket_method { "offline" }
    end

    trait :from_kiosk do
      print_ticket_location { "kiosk" }
    end

    trait :from_counter do
      print_ticket_location { "counter" }
    end

    trait :from_counter_transfer do
      print_ticket_location { "counter-transfer" }
    end

    trait :priority_queue do
      priority { true }
    end

    factory :queue_online, traits: %i[new_queue online]
    factory :queue_online_with_hight_priority, traits: %i[new_queue online priority]

    factory :queue_offline_from_kiosk, traits: %i[new_queue offline from_kiosk]
    factory :queue_offline_from_counter, traits: %i[new_queue offline from_counter]

    factory :queue_offline_from_kiosk_with_hight_priority, traits: %i[new_queue offline from_kiosk priority]
    factory :queue_offline_from_counter_with_hight_priority, traits: %i[new_queue offline from_counter priority]

    factory :queue_offlice_from_kiosk_already_called, traits: %i[new_queue offline from_kiosk already_called] do
      to_create { |instance| instance.save!(context: :next_queue) }
    end
  end
end
