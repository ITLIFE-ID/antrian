class QueueService < ApplicationService
  attr_accessor :id, :service_id, :counter_id, :date, :print_ticket_location, :attend, :transfer, :result

  def company
    @company ||= service.company
  end

  def service
    @service ||= if transfer
      Service.find_by_id(service_id)
    else
      Service.find_by_id(service_id) || counter&.service
    end
  end

  def counter
    @counter ||= Counter.find_by_id(counter_id)
  end

  def find_queue_by_id
    TodayQueue.find_by_id(id)
  end

  def current_queue
    TodayQueue.current_queue(counter)
  end

  def queue_left
    TodayQueue.total_queue_left(service)
  end

  def total_queue_left
    queue_left&.count&.to_i
  end

  def user_attend_to_counter
    attend || false
  end

  def selected_date
    Date.parse(date)
  rescue
    Date.today
  end

  def counter_number_to_text
    Terbilang.convert(counter&.number)&.upcase
  end

  def available_queue_to_call
    queue_left.where(priority: true)&.first || queue_left.where(priority: false)&.first
  end

  def next_queue_number
    TodayQueue.last_queue_in_service(service)&.first&.number.to_i + 1
  end

  def number_to_text
    Terbilang.convert(number).upcase
  end

  def number
    current_queue&.first&.number
  end

  def letter
    current_queue&.first&.letter
  end

  def current_queue_in_counter_text
    queue_number_formater(letter, number)
  end

  def is_date_today?
    selected_date == Date.today
  end

  def mqtt_publish!(action, queue_number_to_print = nil)
    message = {
      from: :server,
      action: action.to_sym,
      service_id: service_id,
      counter_id: counter_id,
      total_queue_left: total_queue_left,
      total_offline_queues: TodayQueue.total_offline_queue(service).count.to_i,
      total_online_queues: TodayQueue.total_online_queue(service).count.to_i,
      missed_queues: missed_queues,
      missed_queues_count: TodayQueue.missed_queues(service).count
    }

    message = message.merge!(current_queue_in_counter_text: current_queue_in_counter_text) if counter_id.present? && ["call", "recall"].include?(action)
    message = message.merge!(play_voice_queue_text: play_voice_queue_text) if ["call", "recall"].include? action
    message = message.merge!(queue_number_to_print: queue_number_to_print) if action == "print_ticket"

    if Rails.env.test?
      message
    else
      Rails.application.config.mqtt_connect.publish(ENV["MQTT_CHANNEL"], message.to_json)
    end
  rescue => e
    return_errors(e)
  end

  def play_voice_queue_text
    "NOMOR_ANTRIAN #{letter} #{number_to_text} SILAHKAN_MENUJU #{service.service_type.slug} #{counter_number_to_text}"
  end

  def print_ticket_method
    (date.blank? || date == Date.today.to_s) ? "offline" : "online"
  end

  def missed_queues
    rows = []
    TodayQueue.missed_queues(service).each do |x|
      queue_number = queue_number_formater(x.letter, x.number)
      badge = (x.print_ticket_method == "online") ? "bg-danger" : "bg-warning"
      priority = x.priority ? "Di utamakan" : "Normal"

      rows << "<tr>
      <td>#{queue_number}<span class='ml-2 badge #{badge}'>#{x.print_ticket_method}</span></td>
      <td>#{priority}</td>
      <td>
        <button type='button' class='btn btn-info font-weight-bolder w-100' onClick='history.go(0)'>Panggil ulang pencet 2x</button>
      </td>
    </tr>"
    end

    rows
  end

  def selected_day
    Date::DAYNAMES.rotate(1)
      .each_with_index.map { |k, v| [k, v + 1] }
      .find { |x| x.first == selected_date.strftime("%A") }
      .second
  end

  def is_not_working_day?(workable)
    check = WorkingDay.find_by(day: selected_day, workable: workable)

    return true if check.blank?

    check.open_time < Time.current && check.closing_time > Time.current
  end

  def is_closed?(closeable)
    check = ClosingDay.find_by(date: selected_date, closeable: closeable)

    return false if check.blank?

    check.start_time < Time.current && check.finish_time > Time.current
  end

  # Validations
  def is_queue_exists?
    raise I18n.t(".queue_not_found") if find_queue_by_id.blank?
  end

  def is_latest_queue_in_counter_available_to_recall?
    raise I18n.t(".last_queue_not_available_to_recall") if find_queue_by_id.blank?
  end

  def is_counter_exists?
    raise I18n.t(".counter_not_found") if counter.blank?
  end

  def is_service_exists?
    raise I18n.t(".service_not_found") if service.blank?
  end

  def is_queue_still_available?
    raise I18n.t(".queue_is_not_available") if total_queue_left <= 0
  end

  def is_service_temporary_closed?
    raise I18n.t(".service_temporary_closed") if service.closed
  end

  def is_counter_temporary_closed?
    raise I18n.t(".counter_temporary_closed") if counter.closed
  end

  def is_company_close_this_day?
    raise I18n.t(".company_is_closed", value: selected_date.to_s) if is_closed?(company)
  end

  def is_service_close_this_day?
    raise I18n.t(".service_is_closed", value: selected_date.to_s) if is_closed?(service)
  end

  def is_quota_exceed?
    raise I18n.t(".quota_is_exceed", max_quota: service.max_quota) if total_queue_left >= service.max_quota
  end

  def is_company_working_this_day?
    raise I18n.t(".company_is_closed", value: Date::DAYNAMES[selected_date.wday]) if is_not_working_day?(company)
  end

  def is_service_working_this_day?
    raise I18n.t(".service_is_closed", value: Date::DAYNAMES[selected_date.wday]) if is_not_working_day?(service)
  end

  def is_current_service_same_to_target?
    raise I18n.t(".current_service_same_to_target", value: service.name) if counter.service == service
  end
end
