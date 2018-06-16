class Ajax::PagesController < ApplicationController
  def index
    pages = Book.first.pages # XXX: Use params[:book_id] and handle not found error

    render json: pages
  end
end
