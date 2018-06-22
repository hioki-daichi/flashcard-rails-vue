class Ajax::PagesController < ApplicationController
  def create
    book_id  = params[:book_id]
    question = params[:question]
    answer   = params[:answer]

    page = Book.find(book_id).pages.create!(question: question, answer: answer)

    render json: page
  end

  def index
    book_id = params[:book_id]

    pages = Book.find(book_id).pages # TODO: Handle not found error

    render json: pages
  end
end
