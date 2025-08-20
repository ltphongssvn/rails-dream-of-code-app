# /spec/requests/admin_dashboard_spec.rb
require 'rails_helper'

RSpec.describe "AdminDashboard", type: :request do
  describe 'GET /dashboard' do
    before do
      # Create an upcoming trimester (start_date less than 6 months from today)
      @upcoming_trimester = Trimester.create!(
        year: "2025",
        term: "Summer",
        start_date: 4.months.from_now.to_date,
        application_deadline: 2.months.from_now.to_date,
        end_date: 7.months.from_now.to_date
      )
    end

    it "displays the upcoming trimester" do
      get "/dashboard"
      expect(response).to be_successful
      expect(response.body).to include("Summer-2025")
    end
  end
end
