# == Schema Information
#
# Table name: file_storages
#
#  id             :bigint           not null, primary key
#  deleted_at     :datetime
#  file_able_type :string
#  file_type      :string
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  company_id     :bigint
#  file_able_id   :bigint
#
# Indexes
#
#  index_file_storages_on_company_id  (company_id)
#  index_file_storages_on_deleted_at  (deleted_at)
#  index_file_storages_on_file_able   (file_able_type,file_able_id)
#
class FileStorage < ApplicationRecord
  belongs_to :file_able, polymorphic: true
  belongs_to :company

  has_many_attached :files

  enum file_type: {music: "MUSIC", video: "VIDEO"}
  validates_presence_of :title, :file_type

  before_validation :get_mime_and_title

  private

  def get_mime_and_title
    
  end
end
