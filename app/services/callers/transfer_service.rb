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
#  index_today_queues_on_counter_id                                 (counter_id)
#  index_today_queues_on_deleted_at                                 (deleted_at)
#  index_today_queues_on_number_and_date_and_service_id_and_letter  (number,date,service_id,letter) UNIQUE
#  index_today_queues_on_parent_id                                  (parent_id)
#  index_today_queues_on_service_id                                 (service_id)
#

module Callers
  class TransferService < QueueService
    def execute
      may_i_transfer_queue_to_another_service?

      TodayQueue.transaction do
        find_queue_by_id.update(attend: true)

        TodayQueue.where(parent_id: id).delete_all

        new_queue = TodayQueue.create(transfer_queue_attributes)

        raise ActiveRecord::Rollback unless new_queue.blank?

        mqtt_publish!("TRANSFER")
      end
    rescue => e
      errors.add(:transfer_service, e.message)
    end

    def may_i_transfer_queue_to_another_service?
      is_queue_exists?
      is_service_exists?
      is_service_close_this_day?
      is_service_temporary_closed?
    end

    def transfer_queue_attributes
      find_queue_by_id.attributes.merge!(
        attend: false,
        print_ticket_time: Time.current,
        print_ticket_location: "counter-transver",
        priority: service.priority,
        service_type_slug: service.service_type.slug,
        start_time: nil,
        finish_time: nil,
        counter_id: nil,
        parent_id: find_queue_by_id.id,
        service_id: service_id
      )
    end
  end
end
