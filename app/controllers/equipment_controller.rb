class EquipmentController < ApplicationController
  before_action :set_equipment, only: [:show, :update, :destroy]

  # GET /equipment - List all with category name, ordered by name, with optional filtering
  def index

    @equipment = Equipment.includes(:category).order(:name)
    
    if params[:status].present?
      @equipment = @equipment.where(status: params[:status])
    end

    
    render json: @equipment.map { |item|
      {
        id: item.id,
        name: item.name,
        serial_number: item.serial_number,
        status: item.status,
        category_id: item.category_id,
        category_name: item.category.name, 
        created_at: item.created_at,
        updated_at: item.updated_at
      }
    }, status: :ok
  end

  # GET /equipment/:id
  def show
    render json: {
      id: @equipment.id,
      name: @equipment.name,
      serial_number: @equipment.serial_number,
      status: @equipment.status,
      category: {
        id: @equipment.category.id,
        name: @equipment.category.name
      },
      # Ordered by performed_at descending
      maintenance_records: @equipment.maintenance_records.order(performed_at: :desc),
      created_at: @equipment.created_at,
      updated_at: @equipment.updated_at
    }, status: :ok
  end

  # POST /equipment - Create equipment
  def create
    @equipment = Equipment.new(equipment_params)

    if @equipment.save
      render json: @equipment, status: :created
    else
      render json: { errors: @equipment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /equipment/:id - Update equipment
  def update
    if @equipment.update(equipment_params)
      render json: @equipment, status: :ok
    else
      render json: { errors: @equipment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /equipment/:id 
  def destroy
    @equipment.destroy
    head :no_content 
  end

  private

  def set_equipment
    @equipment = Equipment.find(params[:id])
  end

  def equipment_params
    params.require(:equipment).permit(:name, :serial_number, :status, :category_id)
  end
end