# frozen_string_literal: true
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  attr_reader :current_user

  before_action :authenticate_request!

  def authenticate_request!
    auth_header = request.headers['Authorization']

    unless auth_header
      render json: { errors: ['Authorization header required'] }, status: 400
      return
    end

    token = auth_header.split(' ', 2).last

    begin
      auth_token = JsonWebToken.decode(token)
    rescue => e
      logger.error(e)
      render json: { errors: ['Token invalid'] }, status: 400
      return
    end

    @current_user = User.find(auth_token[:user_id])
  end

  private

  def record_invalid(e)
    render json: { errors: e.record.errors.full_messages }, status: 400
  end

  def record_not_found(e)
    head 404
  end
end
