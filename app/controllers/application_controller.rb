class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found(exception)
    model_name = exception.model || "Record"
    render json: { error: "#{model_name} not found" }, status: :not_found
  end
end
