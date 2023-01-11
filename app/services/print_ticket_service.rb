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

class PrintTicketService < QueueService
  def execute
    may_i_print_ticket?

    current_queue = TodayQueue.create!(
      attend: false,
      date: selected_date,
      letter: service.letter,
      number: next_queue_number,
      print_ticket_location: print_ticket_location,
      print_ticket_method: print_ticket_method,
      print_ticket_time: selected_date,
      priority: service.priority,
      service_type_slug: service.service_type.slug,
      uniq_number: SecureRandom.uuid,
      service: service
    )

    current_queue_text = "#{current_queue.letter} #{current_queue.number.to_s.rjust(3, "0")}"
    @result = mqtt_publish!("print_ticket", current_queue_text, current_queue.id, current_queue.uniq_number)
  rescue => e
    return_errors(e)
  end

  def may_i_print_ticket?
    is_service_exists?
    is_company_working_this_day?
    is_service_working_this_day?
    is_company_close_this_day?
    is_service_close_this_day?
    is_service_temporary_closed?
    is_quota_exceed?
  end
end
