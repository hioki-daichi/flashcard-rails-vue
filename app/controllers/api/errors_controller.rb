# frozen_string_literal: true
class Api::ErrorsController < ActionController::Base
  skip_forgery_protection

  def routing_error
    render json: { errors: ['No such route.'] }, status: 404
  end
end
