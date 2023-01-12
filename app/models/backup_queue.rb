# frozen_string_literal: true

# == Schema Information
#
# Table name: today_queues
#
#  id                    :bigint           not null, primary key
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
#  process_duration      :integer
#  service_type_slug     :string
#  start_time            :datetime
#  unique_number         :string
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
class BackupQueue < TodayQueue
  scope :total_queue, ->(start_date, end_date, service) { where(date: start_date..end_date, service: service) }
  scope :total_offline_queue, ->(start_date, end_date, service) { total_queue(start_date, end_date, service).where(print_ticket_method: "offline") }
  scope :total_online_queue, ->(start_date, end_date, service) { total_queue(start_date, end_date, service).where(print_ticket_method: "online") }
  scope :performance, ->(start_date, end_date, service) {
    backup_queue ||= total_queue(start_date, end_date, service).select { |x| x.process_duration.present? }
    return 0 if backup_queue.blank?

    total_duration = backup_queue.sum(&:process_duration) / 60 # seconds to minutes
    total_duration > 0 ? today_queue.count / total_duration : 0
  }
end
