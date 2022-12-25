require "administrate/field/base"

class ChildField < Administrate::Field::Base
  def to_s
    data
  end
end
