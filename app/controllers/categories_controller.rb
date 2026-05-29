class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :update, :destroy]

  # GET /categories - List all, ordered alphabetically by name 
  def index
    @categories = Category.order(:name)
    render json: @categories, status: :ok 
  end

  # GET /categories/:id - Show one, including its equipment count 
  def show
    render json: {
      id: @category.id,
      name: @category.name,
      equipment_count: @category.equipment.count,
      created_at: @category.created_at,
      updated_at: @category.updated_at
    }, status: :ok 
  end

  # POST /categories - Create a record 
  def create
    @category = Category.new(category_params)

    if @category.save
      render json: @category, status: :created 
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity 
    end
  end

  # PATCH/PUT /categories/:id - Update a record 
  def update
    if @category.update(category_params)
      render json: @category, status: :ok 
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity 
    end
  end

  # DELETE /categories/:id 
  def destroy
    if @category.equipment.any? 
      count = @category.equipment.count
      render json: { 
        error: "Cannot delete category. #{count} equipment items still belong to it." 
      }, status: :conflict 
    else
      @category.destroy
      head :no_content 
    end
  end

  private

 
  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end