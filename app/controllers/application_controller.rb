class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_invalid(e)
    render json: { errors: e.record.errors.full_messages }, status: 400
  end

  def record_not_found(e)
    head 404
  end
end
