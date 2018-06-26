class Api::PagesController < ApplicationController
  def create
    book_id  = params[:book_id]
    question = params[:question]
    answer   = params[:answer]

    page = Book.find(book_id).pages.create!(question: question, answer: answer)

    render json: page
  end

  def update
    book_id  = params[:book_id]
    page_id  = params[:id]
    question = params[:question]
    answer   = params[:answer]

    page = Book.find(book_id).pages.find(page_id)
    page.update!(question: question, answer: answer)

    render json: page
  end

  def index
    book_id = params[:book_id]

    pages = Book.find(book_id).pages.order(created_at: :asc, id: :asc) # TODO: Handle not found error

    render json: pages
  end

  def destroy
    book_id = params[:book_id]
    page_id = params[:id]

    Book.find(book_id).pages.find(page_id).destroy!

    head :no_content
  end
end
