class Ajax::PagesController < ApplicationController
  def index
    book_id = params[:book_id]

    pages = Book.find(book_id).pages # TODO: Handle not found error

    render json: pages
  end
end
