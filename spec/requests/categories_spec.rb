require 'rails_helper'

RSpec.describe "Categories", type: :request do
  # Create a test user before all tests run
  # Using before(:each) ensures fresh data for each test
  before(:each) do
    # Clear existing data to ensure clean state
    User.destroy_all
    Category.destroy_all
    
    # Create user with ID 1 that our controller expects
    @user = User.create!(
      id: 1,
      email: "test@example.com", 
      first_name: "Test", 
      last_name: "User", 
      time_zone: "UTC"
    )
  end

  describe "GET /categories/new" do
    it "displays the new category form" do
      get new_category_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("New Category")
    end
  end

  describe "POST /categories" do
    context "with valid parameters" do
      it "creates a new category and redirects" do
        expect {
          post categories_path, params: {
            category: { name: "Work", color: "#FF5733" }
          }
        }.to change(Category, :count).by(1)

        expect(response).to redirect_to(categories_path)
        follow_redirect!
        expect(response.body).to include("Category was successfully created")
        expect(response.body).to include("Work")
      end
    end

    context "with invalid parameters (missing name)" do
      it "does not create a category and re-renders the form with errors" do
        expect {
          post categories_path, params: {
            category: { name: "", color: "#FF5733" }
          }
        }.not_to change(Category, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("error")
        expect(response.body).to include("Name can&#39;t be blank")
      end
    end

    context "with invalid color format" do
      it "does not create a category and shows validation error" do
        expect {
          post categories_path, params: {
            category: { name: "Exercise", color: "not-a-color" }
          }
        }.not_to change(Category, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Color must be a valid hex color code")
      end
    end
  end

  describe "GET /categories/:id/edit" do
    it "displays the edit form for an existing category" do
      category = Category.create!(name: "Study", color: "#00FF00", user: @user)

      get edit_category_path(category)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Edit Category")
      expect(response.body).to include("Study")
    end
  end

  describe "PATCH /categories/:id" do
    let(:category) { Category.create!(name: "Original", color: "#000000", user: @user) }

    context "with valid parameters" do
      it "updates the category and redirects" do
        patch category_path(category), params: {
          category: { name: "Updated Name", color: "#FFFFFF" }
        }

        expect(response).to redirect_to(categories_path)
        category.reload
        expect(category.name).to eq("Updated Name")
        expect(category.color).to eq("#FFFFFF")
      end
    end

    context "with invalid parameters" do
      it "does not update and re-renders the form with errors" do
        patch category_path(category), params: {
          category: { name: "", color: "#FFFFFF" }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("error")
        category.reload
        expect(category.name).to eq("Original") # Name unchanged
      end
    end
  end
end
