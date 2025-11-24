# lib/tasks/seed.rake
namespace :db do
  desc "Seed database trên production"
  task seed_production: :environment do
    if Rails.env.production?
      puts "🚀 Seed production database bắt đầu..."
      load Rails.root.join("db/seeds.rb")
      puts "✅ Seed production database hoàn tất!"
    else
      puts "❌ Chỉ chạy task này trên production!"
    end
  end
end
