class QueueService < ApplicationService
  attr_accessor :id, :counter_id, :date, :print_ticket_location, :service_id, :attend, :transfer

  def user_attend_to_counter
    attend || false
  end

  def find_queue_by_id
    @find_queue_by_id ||= TodayQueue.find_by_id(id)
  end

  def counter
    @counter ||= Counter.find_by_id(counter_id)
  end

  def service
    return @service ||= Service.find_by_id(service_id) if transfer

    @service ||= Service.find_by_id(service_id) || counter&.service
  end

  def company
    @company ||= service.company
  end

  def counter_number_to_text
    Terbilang.convert(counter&.number).upcase
  end

  def find_queue
    @find_queue ||= TodayQueue.where("DATE(print_ticket_time) = ?", selected_date.to_s)
  end

  def queue_in_service
    @queue_in_service ||= find_queue.where(service: service)
  end

  def queue_in_counter
    @queue_in_counter ||= find_queue.where(counter: counter)
  end

  def last_queue_in_counter
    @last_queue_in_counter ||= queue_in_counter.order(id: :desc).limit(1)
  end

  def last_queue_in_counter_available_to_recall
    @last_queue_in_counter_available_to_recall ||= last_queue_in_counter.where(attend: false)
  end

  def last_queue_in_service
    @last_queue_in_service ||= queue_in_service.order(id: :desc).limit(1)
  end

  def available_queue_to_call_in_service
    @available_queue_to_call_in_service ||= queue_in_service.where(counter: nil)
  end

  def available_regular_queue_to_call
    @available_regular_queue_to_call ||= available_queue_to_call_in_service.order(id: :asc).limit(1)
  end

  def available_priority_queue_to_call
    @available_priority_queue_to_call ||= available_queue_to_call_in_service.where(priority: true).order(id: :asc).limit(1)
  end

  def available_queue_to_call
    @available_queue_to_call ||= available_priority_queue_to_call&.first || available_regular_queue_to_call&.first
  end

  def next_queue_number
    last_queue_number = last_queue_in_service.try(:first).try(:number).to_i

    last_queue_number + 1
  end

  def total_queue_left
    @total_queue_left ||= available_queue_to_call_in_service&.count.to_i
  end

  def letter
    @letter ||= last_queue_in_counter.first&.letter || service.letter
  end

  def number
    @number ||= last_queue_in_counter.first&.number.to_i
  end

  def number_to_text
    @number_to_text ||= Terbilang.convert(number).upcase
  end

  def current_queue_in_counter_text
    @current_queue_in_counter_text ||= ApplicationHelper.queue_number_formater(letter, number)
  end

  def selected_date
    Date.parse(date)
  rescue
    Date.today
  end

  def is_date_today?
    selected_date == Date.today
  end

  def mqtt_publish!(action, queue_number_to_print = nil)
    return if Rails.env.test?

    begin
      result = {
        action: action,
        queue_number_to_print: queue_number_to_print,
        current_queue_in_counter_text: current_queue_in_counter_text,
        play_voice_queue_text: play_voice_queue_text,
        service_id: service_id,
        counter_id: counter_id,
        total_queue_left: TodayQueue.total_queue_left(service).count.to_i,
        total_offline_queues: TodayQueue.total_offline_queue(service).count.to_i,
        total_online_queues: TodayQueue.total_online_queue(service).count.to_i,
        missed_queues: TodayQueue.missed_queues(service).to_json
      }

      Rails.application.config.mqtt_connect.publish(ENV["MQTT_CHANNEL"], result.to_json)
    rescue => e
      return_errors(e)
    end
  end

  def play_voice_queue_text
    "NOMOR_ANTRIAN #{letter} #{number_to_text} SILAHKAN_MENUJU #{service.service_type.slug} #{counter_number_to_text}"
  end

  def print_ticket_method
    date.blank? ? "offline" : "online"
  end

  def selected_day
    Date::DAYNAMES.rotate(1)
      .each_with_index.map { |k, v| [k, v + 1] }
      .find { |x| x.first == selected_date.strftime("%A") }.second
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

  def is_queue_exists?
    raise I18n.t(".queue_not_found") if find_queue_by_id.blank?
  end

  def is_latest_queue_in_counter_available_to_recall?
    raise I18n.t(".last_queue_not_available_to_recall") if last_queue_in_counter_available_to_recall.blank?
  end

  def is_counter_exists?
    raise I18n.t(".counter_not_found") if counter.blank?
  end

  def is_service_exists?
    raise I18n.t(".service_not_found") if service.blank?
  end

  def is_queue_still_available?
    raise I18n.t(".queue_is_not_available") if available_queue_to_call_in_service.count <= 0
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
end
