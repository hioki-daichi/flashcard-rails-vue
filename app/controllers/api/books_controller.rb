class Api::BooksController < ApplicationController
  def create
    title = params[:title]
    book = Book.create!(title: title)
    render json: book
  end

  def update
    book_id = params[:id]
    title   = params[:title]

    book = Book.find(book_id)
    book.update!(title: title)

    render json: book
  end

  def index
    books = Book.order(created_at: :desc, id: :desc)
    render json: books
  end

  def destroy
    book_id = params[:id]
    Book.find(book_id).destroy!
    head :no_content
  end
end
