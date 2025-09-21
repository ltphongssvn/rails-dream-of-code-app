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
