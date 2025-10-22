# File path: ~/code/ltphongssvn/rails-dream-of-code-app/app/controllers/trimesters_controller.rb
class TrimestersController < ApplicationController
  # Authorization: Only admins can create, update, and delete trimesters
  # Anyone can view the list and individual trimesters
  before_action :require_admin, only: %i[ new create edit update destroy ]
  before_action :set_trimester, only: %i[ show edit update destroy ]
  
  # GET /trimesters
  def index
    @trimesters = Trimester.all
  end
  
  # GET /trimesters/:id
  def show
  end
  
  # GET /trimesters/new
  def new
    @trimester = Trimester.new
  end
  
  # GET /trimesters/:id/edit
  def edit
  end
  
  # POST /trimesters
  def create
    @trimester = Trimester.new(trimester_params)
    
    respond_to do |format|
      if @trimester.save
        format.html { redirect_to @trimester, notice: "Trimester was successfully created." }
        format.json { render :show, status: :created, location: @trimester }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @trimester.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /trimesters/:id
  def update
    respond_to do |format|
      if @trimester.update(trimester_params)
        format.html { redirect_to @trimester, notice: "Trimester was successfully updated." }
        format.json { render :show, status: :ok, location: @trimester }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @trimester.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /trimesters/:id
  def destroy
    @trimester.destroy!
    
    respond_to do |format|
      format.html { redirect_to trimesters_url, notice: "Trimester was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions
    def set_trimester
      @trimester = Trimester.find(params[:id])
    end
    
    # Only allow a list of trusted parameters through
    def trimester_params
      params.require(:trimester).permit(:term, :year, :start_date, :end_date, :application_deadline)
    end
end
# File: app/controllers/trimesters_controller.rb
class TrimestersController < ApplicationController
  before_action :set_trimester, only: [:show, :edit, :update, :destroy]

  # GET /trimesters or /trimesters.json
  def index
    @trimesters = Trimester.all
  end

  # GET /trimesters/1 or /trimesters/1.json
  def show
  end

  # GET /trimesters/new
  def new
    @trimester = Trimester.new
  end

  # GET /trimesters/1/edit
  def edit
  end

  # POST /trimesters or /trimesters.json
  def create
    @trimester = Trimester.new(trimester_params)

    respond_to do |format|
      if @trimester.save
        format.html { redirect_to @trimester, notice: "Trimester was successfully created." }
        format.json { render :show, status: :created, location: @trimester }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @trimester.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trimesters/1 or /trimesters/1.json
  def update
    # Check if application_deadline parameter is missing
    if params.dig(:trimester, :application_deadline).blank?
      respond_to do |format|
        format.html { render :edit, status: :bad_request }
        format.json { render json: { error: "Application deadline is required" }, status: :bad_request }
      end
      return
    end

    # Validate date format
    begin
      Date.parse(params.dig(:trimester, :application_deadline)) if params.dig(:trimester, :application_deadline).present?
    rescue ArgumentError
      respond_to do |format|
        format.html { render :edit, status: :bad_request }
        format.json { render json: { error: "Invalid date format" }, status: :bad_request }
      end
      return
    end

    respond_to do |format|
      if @trimester.update(trimester_params)
        format.html { redirect_to @trimester, notice: "Trimester was successfully updated." }
        format.json { render :show, status: :ok, location: @trimester }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @trimester.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trimesters/1 or /trimesters/1.json
  def destroy
    @trimester.destroy!

    respond_to do |format|
      format.html { redirect_to trimesters_path, status: :see_other, notice: "Trimester was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_trimester
    @trimester = Trimester.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { render plain: "Trimester not found", status: :not_found }
      format.json { render json: { error: "Trimester not found" }, status: :not_found }
    end
  end

  # Only allow a list of trusted parameters through.
  def trimester_params
    params.require(:trimester).permit(:year, :term, :application_deadline, :start_date, :end_date)
  end
end
