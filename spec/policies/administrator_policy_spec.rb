require "rails_helper"

RSpec.describe AdministratorPolicy, type: :policy do
  # See https://actionpolicy.evilmartians.io/#/testing?id=rspec-dsl
  #
  let(:user) { build_stubbed :user }
  let(:administrator) { build_stubbed :administrator }
  let(:record) { build_stubbed :building }

  describe "Check if the user is not administrator" do
    let(:context) { {user: user} }

    describe_rule :index? do
      failed "You are not administrator"
    end

    describe_rule :show? do
      failed "You are not administrator"
    end

    describe_rule :new? do
      failed "You are not administrator"
    end

    describe_rule :edit? do
      failed "You are not administrator"
    end

    describe_rule :destroy? do
      failed "You are not administrator"
    end
  end

  describe "Check if the user is administrator" do
    let(:context) { {user: administrator} }

    describe_rule :index? do
      succeed "You are administrator"
    end

    describe_rule :show? do
      succeed "You are administrator"
    end

    describe_rule :new? do
      succeed "You are administrator"
    end

    describe_rule :edit? do
      succeed "You are administrator"
    end

    describe_rule :destroy? do
      succeed "You are not administrator"
    end
  end

  describe_rule :create? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  describe_rule :manage? do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
