class AddColumnParentIdToCompanies < ActiveRecord::Migration[7.0]
  def change
    add_reference :companies, :parent, index: true
  end
end
