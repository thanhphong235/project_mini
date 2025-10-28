# Gửi thống kê ngày cuối tháng lúc 23:59
every '59 23 28-31 * *' do
  runner "MonthlyOrderSummaryJob.perform_later"
end
