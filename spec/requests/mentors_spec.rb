# spec/requests/mentors_spec.rb
require 'rails_helper'

RSpec.describe "Mentors", type: :request do
  # Test for the mentors list route (index action)
  describe "GET /mentors" do
    before do
      # Create sample mentors for testing
      @mentor1 = Mentor.create!(
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@example.com",
        max_concurrent_students: 5
      )

      @mentor2 = Mentor.create!(
        first_name: "Jane",
        last_name: "Smith",
        email: "jane.smith@example.com",
        max_concurrent_students: 3
      )
    end

    it "returns a successful response" do
      get "/mentors"
      expect(response).to have_http_status(:success)
    end

    it "returns HTTP status 200" do
      get "/mentors"
      expect(response).to have_http_status(200)
    end

    # Removed render_template test - requires rails-controller-testing gem

    it "includes all mentors in the response" do
      get "/mentors"
      expect(response.body).to include("John")
      expect(response.body).to include("Doe")
      expect(response.body).to include("Jane")
      expect(response.body).to include("Smith")
    end

    it "assigns @mentors variable" do
      get "/mentors"
      # Check the response body for mentor data
      expect(response.body).to match(/john\.doe@example\.com/)
      expect(response.body).to match(/jane\.smith@example\.com/)
    end
  end

  # Test for the mentors show route (show action)
  describe "GET /mentors/:id" do
    before do
      @mentor = Mentor.create!(
        first_name: "Robert",
        last_name: "Johnson",
        email: "robert.johnson@example.com",
        max_concurrent_students: 4
      )
    end

    context "when the mentor exists" do
      it "returns a successful response" do
        get "/mentors/#{@mentor.id}"
        expect(response).to have_http_status(:success)
      end

      it "returns HTTP status 200" do
        get "/mentors/#{@mentor.id}"
        expect(response).to have_http_status(200)
      end

      # Removed render_template test - requires rails-controller-testing gem

      it "includes the mentor's information in the response" do
        get "/mentors/#{@mentor.id}"
        expect(response.body).to include("Robert")
        expect(response.body).to include("Johnson")
        expect(response.body).to include("robert.johnson@example.com")
      end
    end

    context "when the mentor does not exist" do
      it "returns a 404 not found status" do
        # Rails converts RecordNotFound to 404 in request specs
        get "/mentors/999999"
        expect(response).to have_http_status(404)
      end
    end
  end

  # Additional test for JSON format responses
  describe "JSON responses" do
    before do
      @mentor = Mentor.create!(
        first_name: "Alice",
        last_name: "Williams",
        email: "alice.williams@example.com",
        max_concurrent_students: 6
      )
    end

    describe "GET /mentors.json" do
      it "returns mentors as JSON" do
        get "/mentors", headers: { "Accept" => "application/json" }

        expect(response).to have_http_status(:success)
        expect(response.content_type).to match(/application\/json/)

        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
      end
    end

    describe "GET /mentors/:id.json" do
      it "returns a specific mentor as JSON" do
        get "/mentors/#{@mentor.id}", headers: { "Accept" => "application/json" }

        expect(response).to have_http_status(:success)
        expect(response.content_type).to match(/application\/json/)

        json_response = JSON.parse(response.body)
        expect(json_response["first_name"]).to eq("Alice")
        expect(json_response["last_name"]).to eq("Williams")
      end
    end
  end
end
