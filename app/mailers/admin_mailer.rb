class AdminMailer < ApplicationMailer
  def monthly_statistics(email, stats)
    @stats = stats
    mail(to: email, subject: "Monthly Order Stats")
  end
end
