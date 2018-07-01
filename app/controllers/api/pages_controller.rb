class Api::PagesController < ApplicationController
  def create
    book_id  = params[:book_id]
    path     = params[:path]
    question = params[:question]
    answer   = params[:answer]

    page = Book.find(book_id).pages.create!(path: path, question: question, answer: answer)

    render json: page
  end

  def update
    book_id  = params[:book_id]
    page_id  = params[:id]
    path     = params[:path]
    question = params[:question]
    answer   = params[:answer]

    page = Book.find(book_id).pages.find(page_id)
    page.update!(path: path, question: question, answer: answer)

    render json: page
  end

  def index
    book_id = params[:book_id]

    pages = Book.find(book_id).pages.order(position: :asc, created_at: :asc, id: :asc) # TODO: Handle not found error

    render json: pages
  end

  def destroy
    book_id = params[:book_id]
    page_id = params[:id]

    Book.find(book_id).pages.find(page_id).destroy!

    head :no_content
  end

  def positions
    book_id = params[:book_id]
    book = current_user.books.find(book_id)
    page_ids = JSON.parse(params[:page_ids])
    PageArranger.arrange!(book, page_ids)
    head 200
  end
end
