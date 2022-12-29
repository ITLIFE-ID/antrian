# == Schema Information
#
# Table name: file_storages
#
#  id             :bigint           not null, primary key
#  deleted_at     :datetime
#  file_able_type :string
#  file_type      :string
#  title          :string
#  company_id     :bigint
#  file_able_id   :bigint
#
# Indexes
#
#  index_file_storages_on_company_id  (company_id)
#  index_file_storages_on_file_able   (file_able_type,file_able_id)
#
require "rails_helper"

RSpec.describe FileStorage, type: :model do
  it { should belong_to :file_able }
  it { should belong_to :company }
  it { should have_db_column(:file_able_id).of_type(:integer) }
  it { should have_db_column(:file_able_type).of_type(:string) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :file_type }
end
