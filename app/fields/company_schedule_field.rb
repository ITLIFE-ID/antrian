require "administrate/field/base"

class CompanyScheduleField < Administrate::Field::Base
  def to_s
    data
  end
end
