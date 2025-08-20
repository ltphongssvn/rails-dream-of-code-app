# /app/controllers/admin_dashboard_controller.rb
class AdminDashboardController < ApplicationController
  def index
    @upcoming_trimester = Trimester.where('start_date < ?', 6.months.from_now).first
  end
end
