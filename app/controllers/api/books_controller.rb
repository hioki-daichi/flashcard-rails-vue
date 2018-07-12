class Api::BooksController < ApplicationController
  def index
    books = current_user.books.order(position: :asc, created_at: :desc, id: :desc)
    render json: books
  end

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

  def destroy
    book_id = params[:id]
    current_user.books.find(book_id).destroy!
    head :no_content
  end

  def import
    file = params[:file]
    col_sep = params[:col_sep]
    book = nil
    ActiveRecord::Base.transaction do
      book = current_user.books.create!(title: "Book_#{Time.current.strftime('%Y%m%d%H%M%S')}")
      Page.import!(BookTranslator.from_csv(file, col_sep, book))
    end
    render json: book
  end

  def export
    book_id = params[:id]
    book = current_user.books.find(book_id)
    csv_data = BookTranslator.to_csv(book)
    send_data csv_data, type: 'text/csv'
  end

  def positions
    book_ids = JSON.parse(params[:book_ids])
    BookArranger.arrange!(current_user, book_ids)
    head 200
  end
end
