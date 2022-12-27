require "rails_helper"

RSpec.describe CompanyPolicy, type: :policy do
  # See https://actionpolicy.evilmartians.io/#/testing?id=rspec-dsl
  #
  let(:admin) { create :administrator }
  let(:record) { build_stubbed :company }
  let(:context) { {user: admin} }

  describe "Check if the user is administrator" do
    before { admin.update(id: 1) }

    describe_rule :index? do
      succeed "You are super administrator"
    end

    describe_rule :show? do
      succeed "You are super administrator"
    end

    describe_rule :new? do
      succeed "You are super administrator"
    end

    describe_rule :edit? do
      succeed "You are super administrator"
    end

    describe_rule :destroy? do
      succeed "You are super administrator"
    end
  end

  describe "Check if the user is administrator" do
    describe_rule :index? do
      before { admin.update(id: 2) }
      failed "You are not super administrator"
    end

    describe_rule :show? do
      failed "You are not super administrator"
    end

    describe_rule :new? do
      failed "You are not super administrator"
    end

    describe_rule :edit? do
      failed "You are not super administrator"
    end

    describe_rule :destroy? do
      failed "You are not super administrator"
    end
  end
end
