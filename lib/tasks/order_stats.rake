namespace :orders do
  desc "Send monthly stats to admin"
  task monthly: :environment do
    start_date = Date.today.beginning_of_month
    end_date = Date.today.end_of_month
    orders = Order.where(ordered_at: start_date..end_date)

    total_orders = orders.count
    total_revenue = orders.sum(:total_price)
    top_products = orders.joins(:order_items)
                         .group("products.name")
                         .sum("order_items.quantity")
                         .sort_by { |_k,v| -v }
                         .first(10)
                         .to_h

    Admin.pluck(:email).each do |email|
      AdminMailer.monthly_statistics(email, total_orders, total_revenue, top_products).deliver_now
    end
  end
end
