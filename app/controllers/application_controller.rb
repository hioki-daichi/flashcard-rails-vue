class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  attr_reader :current_user

  def current_user
    @current_user = User.find_by!(email: 'hiokidaichi@gmail.com') # XXX
  end

  private

  def record_invalid(e)
    render json: { errors: e.record.errors.full_messages }, status: 400
  end

  def record_not_found(e)
    head 404
  end
end
