class CalculateDashboardWorker
  include Sidekiq::Worker

  def perform(*args)
    {
      monthly_offline_queues: 0,
      weekly_offline_queues: 0,
      yearly_offline_queues: 0,
      monthly_online_queues: 0,
      weekly_online_queues: 0,
      yearly_online_queues: 0
    }
  end
end
