require 'rails_helper'

RSpec.describe "Trimesters", type: :request do
  # Test data setup - we'll create a trimester to test with
  let(:trimester) { Trimester.create!(term: "Fall", year: 2025, start_date: "2025-09-01", end_date: "2025-12-20", application_deadline: "2025-08-01") }
  let(:valid_attributes) { { trimester: { application_deadline: "2025-07-15" } } }
  let(:missing_deadline) { { trimester: { application_deadline: "" } } }
  let(:invalid_date) { { trimester: { application_deadline: "not-a-date" } } }
  
  describe "GET /trimesters/:id/edit" do
    it "displays the application deadline label" do
      get edit_trimester_path(trimester)
      expect(response.body.downcase).to include("application deadline")
    end
  end
  
  describe "PUT /trimesters/:id" do
    context "with valid parameters (happy path)" do
      it "updates the trimester and returns success" do
        put trimester_path(trimester), params: valid_attributes
        expect(response).to have_http_status(:redirect)
        trimester.reload
        expect(trimester.application_deadline.to_s).to eq("2025-07-15")
      end
    end
    
    context "with missing application_deadline" do
      it "returns 400 Bad Request" do
        put trimester_path(trimester), params: missing_deadline
        expect(response).to have_http_status(:bad_request)
      end
    end
    
    context "with invalid date format" do
      it "returns 400 Bad Request" do
        put trimester_path(trimester), params: invalid_date
        expect(response).to have_http_status(:bad_request)
      end
    end
    
    context "with non-existent trimester ID" do
      it "returns 404 Not Found" do
        put trimester_path(999999), params: valid_attributes
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
