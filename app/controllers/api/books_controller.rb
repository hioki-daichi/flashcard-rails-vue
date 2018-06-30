class Api::BooksController < ApplicationController
  def create
    title = params[:title]
    book = current_user.books.create!(title: title)
    render json: book
  end

  def update
    book_id = params[:id]
    title   = params[:title]

    book = current_user.books.find(book_id)
    book.update!(title: title)

    render json: book
  end

  def index
    books = current_user.books.order(created_at: :desc, id: :desc)
    render json: books
  end

  def destroy
    book_id = params[:id]
    current_user.books.find(book_id).destroy!
    head :no_content
  end

  def export
    book_id = params[:id]
    book = current_user.books.find(book_id)
    csv_data = BookTranslator.to_csv(book)
    send_data csv_data, type: 'text/csv'
  end
end
