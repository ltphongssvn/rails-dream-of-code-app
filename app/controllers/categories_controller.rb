class CategoriesController < ApplicationController
  before_action :set_category, only: [:edit, :update]
  
  def index
    @categories = Category.all
  end
  
  def new
    @category = Category.new
  end
  
  def create
    @category = Category.new(category_params)
    # For now, we'll hardcode a user_id. In a real app, this would be current_user
    @category.user_id = 1 # Temporary until authentication is implemented
    
    if @category.save
      redirect_to categories_path, notice: 'Category was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    # @category is set by before_action
  end
  
  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: 'Category was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_category
    @category = Category.find(params[:id])
  end
  
  def category_params
    params.require(:category).permit(:name, :color, :parent_category_id)
  end
end
