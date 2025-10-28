namespace :system do
  desc "Send monthly order statistics to admin"
  task monthly_statistics: :environment do
    SystemNotifier.send_monthly_statistics
  end
end
