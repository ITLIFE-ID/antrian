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
require "rails_helper"

RSpec.describe BackupQueue, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
