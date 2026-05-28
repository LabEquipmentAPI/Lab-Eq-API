class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found(exception)
    model_name = exception.model.underscore.humanize if exception.model
    render json: { error: "#{model_name || 'Record'} not found" }, status: :not_found
  end
end