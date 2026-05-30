class MaintenanceRecordsController < ApplicationController
  before_action :set_maintenance_record, only: [:show, :update, :destroy] 

  # GET /maintenance_records - List all with equipment name, sorted by date descending, optional filter
  def index
    
    @maintenance_records = MaintenanceRecord.includes(:equipment).order(performed_at: :desc)

    if params[:equipment_id].present?
      @maintenance_records = @maintenance_records.where(equipment_id: params[:equipment_id])
    end

    render json: @maintenance_records.map { |record|
      {
        id: record.id,
        description: record.description,
        performed_at: record.performed_at,
        equipment_id: record.equipment_id,
        equipment_name: record.equipment&.name, 
        created_at: record.created_at,
        updated_at: record.updated_at
      }
    }, status: :ok
  end

  # GET /maintenance_records/:id - Show a single record with its equipment name
  def show
    render json: {
      id: @maintenance_record.id,
      description: @maintenance_record.description,
      performed_at: @maintenance_record.performed_at,
      equipment_id: @maintenance_record.equipment_id,
      equipment_name: @maintenance_record.equipment&.name,
      created_at: @maintenance_record.created_at,
      updated_at: @maintenance_record.updated_at
    }, status: :ok
  end

  # POST /maintenance_records - Create a record 
  def create
    @maintenance_record = MaintenanceRecord.new(maintenance_record_params)

    if @maintenance_record.save
      render json: @maintenance_record, status: :created 
    else
      render json: { errors: @maintenance_record.errors.full_messages }, status: :unprocessable_entity 
    end
  end

  # PATCH/PUT /maintenance_records/:id - Update a record
  def update
    if @maintenance_record.update(maintenance_record_params)
      render json: @maintenance_record, status: :ok 
    else
      render json: { errors: @maintenance_record.errors.full_messages }, status: :unprocessable_entity 
    end
  end

  # DELETE /maintenance_records/:id - Delete a record
  def destroy
    @maintenance_record.destroy
    head :no_content 
  end

  private

  def set_maintenance_record
    @maintenance_record = MaintenanceRecord.find(params[:id])
  end

  def maintenance_record_params
    params.require(:maintenance_record).permit(:description, :performed_at, :equipment_id)
  end
end