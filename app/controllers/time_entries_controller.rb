class TimeEntriesController < ApplicationController
  before_action :set_time_entry, only: [:show, :edit, :update]
  before_action :load_categories, only: [:new, :create, :edit, :update]
  
  def index
    @time_entries = TimeEntry.includes(:category).order(date: :desc, hour: :desc)
  end
  
  def show
    # @time_entry is set by before_action
  end
  
  def new
    @time_entry = TimeEntry.new
    @time_entry.date = Date.current # Default to today's date for convenience
  end
  
  def create
    @time_entry = TimeEntry.new(time_entry_params)
    # Temporary: assign to our test user. In production, use current_user
    @time_entry.user_id = 1
    
    if @time_entry.save
      redirect_to time_entries_path, notice: 'Time entry was successfully logged.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    # @time_entry and @categories are set by before_actions
  end
  
  def update
    if @time_entry.update(time_entry_params)
      redirect_to time_entry_path(@time_entry), notice: 'Time entry was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_time_entry
    @time_entry = TimeEntry.find(params[:id])
  end
  
  def load_categories
    # Load categories for the dropdown - in production, scope to current user
    @categories = Category.where(user_id: 1).order(:name)
  end
  
  def time_entry_params
    params.require(:time_entry).permit(:category_id, :date, :hour, :duration_minutes, :notes)
  end
end
