# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

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
    rescue JWT::ExpiredSignature
      render json: { errors: ['Token expired'] }, status: 419
      return
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
    render json: { errors: ['Resource not found'] }, status: 404
  end

  def parameter_missing(e)
    render json: { errors: [e.message] }, status: 400
  end
end
