class EquipmentController < ApplicationController
  before_action :set_equipment, only: [:show, :update, :destroy][cite: 6]

  # GET /equipment - List all with category name, ordered by name, with optional filtering
  def index

    @equipment = Equipment.includes(:category).order(:name)[cite: 6]
    
    if params[:status].present?
      @equipment = @equipment.where(status: params[:status])[cite: 6]
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
    }, status: :ok[cite: 6]
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
      maintenance_records: @equipment.maintenance_records.order(performed_at: :desc),[cite: 6]
      created_at: @equipment.created_at,
      updated_at: @equipment.updated_at
    }, status: :ok[cite: 6]
  end

  # POST /equipment - Create equipment
  def create
    @equipment = Equipment.new(equipment_params)[cite: 6]

    if @equipment.save[cite: 6]
      render json: @equipment, status: :created[cite: 6]
    else
      render json: { errors: @equipment.errors.full_messages }, status: :unprocessable_entity[cite: 6]
    end
  end

  # PATCH/PUT /equipment/:id - Update equipment
  def update
    if @equipment.update(equipment_params)[cite: 6]
      render json: @equipment, status: :ok[cite: 6]
    else
      render json: { errors: @equipment.errors.full_messages }, status: :unprocessable_entity[cite: 6]
    end
  end

  # DELETE /equipment/:id 
  def destroy
    @equipment.destroy[cite: 6]
    head :no_content 
  end

  private

  def set_equipment
    @equipment = Equipment.find(params[:id])[cite: 6]
  end

  def equipment_params
    params.require(:equipment).permit(:name, :serial_number, :status, :category_id)[cite: 6]
  end
end