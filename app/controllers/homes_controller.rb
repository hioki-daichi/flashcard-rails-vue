class HomesController < ApplicationController
  skip_before_action :authenticate_request!

  def welcome
  end

  def redirect_to_root
    redirect_to root_path
  end
end
