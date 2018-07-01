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
    books = current_user.books.order(position: :asc, created_at: :desc, id: :desc)
    render json: books
  end

  def destroy
    book_id = params[:id]
    current_user.books.find(book_id).destroy!
    head :no_content
  end

  def import
    file = params[:file]
    book = BookTranslator.from_csv(file)
    book.user = current_user
    book.save!
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
