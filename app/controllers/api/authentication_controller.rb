class Api::AuthenticationController < ApplicationController
  skip_before_action :authenticate_request!

  def authenticate
    email    = params.require(:email)
    password = params.require(:password)

    user = User.find_by(email: email)

    if user&.authenticate(password)
      render json: { token: JsonWebToken.encode(user_id: user.id) }.to_json
    else
      head 401
    end
  rescue ActionController::ParameterMissing
    head 401
  end
end
