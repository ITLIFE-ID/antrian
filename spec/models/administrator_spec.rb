# == Schema Information
#
# Table name: administrators
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  deleted_at             :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  name                   :string
#  phone_number           :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  company_id             :bigint
#
# Indexes
#
#  index_administrators_on_company_id            (company_id)
#  index_administrators_on_confirmation_token    (confirmation_token) UNIQUE
#  index_administrators_on_deleted_at            (deleted_at)
#  index_administrators_on_email                 (email) UNIQUE
#  index_administrators_on_email_and_company_id  (email,company_id) UNIQUE
#  index_administrators_on_reset_password_token  (reset_password_token) UNIQUE
#  index_administrators_on_unlock_token          (unlock_token) UNIQUE
#
require "rails_helper"

RSpec.describe Administrator, type: :model do
  it { should belong_to :company }
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :phone_number }
  it { should validate_uniqueness_of(:email).case_insensitive }
end
