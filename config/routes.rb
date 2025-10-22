# File path: ~/code/ltphongssvn/code-the-dream-knifejaw-rails/practice/ThanhPhongLe/week-01/rails-dream-of-code-app/config/routes.rb
# This file defines all the URL routes for the Rails Dream of Code application
# Resolved merge conflict: Combined Week 7 admin dashboard route with Week 9 trimesters resources

Rails.application.routes.draw do
  # Authentication routes
  get "login" => "sessions#new", as: :login
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy", as: :logout

  resources :students
  # Student routes with custom dashboard member action
  # The member block adds a /students/:id/dashboard route for individual student dashboards
  resources :students do
    member do
      get :dashboard
    end
  end

  # Standard RESTful resources for core models
  # Each of these creates index, show, new, create, edit, update, and destroy routes
  resources :mentors
  resources :enrollments
  resources :mentor_enrollment_assignments
  resources :lessons

  # Courses with nested submissions
  # The nested route creates paths like /courses/:course_id/submissions/new
  resources :courses do
    resources :submissions, only: [:new, :create]
  end

  # Coding classes resource
  resources :coding_classes

  # Week 9 Addition: Trimesters resource
  # Provides full CRUD operations for managing academic trimesters
  resources :trimesters

  # Week 7 Addition: Admin dashboard custom route
  # Creates a non-RESTful route for the admin dashboard at /dashboard
  # Maps to AdminDashboardController#index action
  get "dashboard" => "admin_dashboard#index", as: :admin_dashboard

  # Rails standard routes below this line
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Health check endpoint
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA routes (commented out by default)
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # API Routes
  namespace :api do
    namespace :v1 do
      resources :courses, only: [] do
        resources :enrollments, only: [:index]
      end
    end
  end

  # Root route - defines what shows at the base URL (/)
  # Points to the home controller's index action
  root "home#index"
end