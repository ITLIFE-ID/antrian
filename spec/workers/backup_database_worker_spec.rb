require "rails_helper" # include in your RSpec file
require "sidekiq/testing" # include in your Rspec file
Sidekiq::Testing.fake! # include in your RSpec file
RSpec.describe BackupDatabaseWorker, type: :worker do
  let(:time) { (Time.zone.today + 6.hours).to_datetime }
  let(:scheduled_job) { described_class.perform_at(time, "Awesome", true) }
  describe "testing worker" do
    it "ActionItemWorker jobs are enqueued in the scheduled queue" do
      described_class.perform_async
      assert_equal :scheduled, described_class.queue
    end
    it "goes into the jobs array for testing environment" do
      expect do
        described_class.perform_async
      end.to change(described_class.jobs, :size).by(1)
      described_class.new.perform
    end
    context "occurs daily" do
      it "occurs at expected time" do
        scheduled_job
        assert_equal true, described_class.jobs.last["jid"].include?(scheduled_job)
        expect(described_class).to have_enqueued_sidekiq_job("Awesome", true)
      end
    end
  end
end
