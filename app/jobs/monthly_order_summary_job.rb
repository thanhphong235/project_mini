# app/jobs/monthly_order_summary_job.rb
class MonthlyOrderSummaryJob < ApplicationJob
  queue_as :default

  def perform
    now = Time.current
    last_month = now.last_month
    orders = Order.where(created_at: last_month.beginning_of_month..last_month.end_of_month)

    AdminMailer.with(
      orders: orders,
      month: last_month.month,
      year: last_month.year
    ).monthly_order_summary.deliver_now
  end
end
