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
class TodayQueue < ApplicationRecord
  has_many :children, class_name: "TodayQueue", foreign_key: "parent_id", inverse_of: :parent
  belongs_to :parent, class_name: "TodayQueue", foreign_key: "parent_id", optional: true,
    inverse_of: :children

  belongs_to :service
  belongs_to :counter, optional: true

  validates_inclusion_of [:priority, :attend], in: [false, true]
  validates_presence_of :letter, :uniq_number, :print_ticket_location, :print_ticket_time, :number,
    :service_type_slug, :date

  validates :letter, presence: true, uniqueness: {scope: %i[service_id number date]}

  validates_numericality_of :number, only_integer: true, greater_than_or_equal_to: 1,
    less_than_or_equal_to: 999

  validates_numericality_of :process_duration, only_integer: true, greater_than_or_equal_to: 1, allow_blank: true

  with_options on: :next_queue do
    validates_datetime :start_time, after: :print_ticket_time, on_or_after: :today
    validates_datetime :finish_time, after: :start_time, allow_blank: true, on_or_after: :today
  end

  validates_datetime :print_ticket_time, on_or_after: :today
  validates_date :date, on_or_after: :today

  after_save { BackupQueue.upsert(attributes) }
  scope :total_queue, ->(service) { where(date: Date.today, service: service) }
  scope :missed_queues, ->(service) { total_queue(service).where.not(counter_id: nil).where(attend: false) }
  scope :total_queue_left, ->(service) { total_queue(service).where(attend: false) }
  scope :current_queue, ->(counter) { where(date: Date.today, counter: counter, attend: false).order(id: :desc) }
  scope :total_processed, ->(service) { total_queue(service).where(attend: true).where.not(finish_time: nil) }
  scope :total_unprocessed, ->(service) { total_queue(service).where(attend: false, finish_time: nil) }
  scope :total_offline_queue, ->(service) { total_queue(service).where(print_ticket_method: "offline") }
  scope :total_online_queue, ->(service) { total_queue(service).where(print_ticket_method: "online") }

  scope :total_future_queue, ->(service) { where("date > ?", Date.today, service: services) }
  scope :total_future_offline_queue, ->(service) { total_future_queue(service).where(print_ticket_method: "offline") }
  scope :total_future_online_queue, ->(service) { total_future_queue(service).where(print_ticket_method: "online") }

  scope :performance, ->(service) {
    @today_queue ||= total_queue(service)
    return 0 if @today_queue.blank?
    total_duration = @today_queue.sum(&:process_duration) / 60 # seconds to minutes
    @today_queue.count / total_duration
  }

  def letter=(value)
    super(value&.upcase)
  end
end
