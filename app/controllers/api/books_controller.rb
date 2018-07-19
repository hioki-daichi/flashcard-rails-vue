class Api::BooksController < ApplicationController
  # GET /api/books
  def index
    books = current_user.books.order(row_order: :asc, created_at: :desc, id: :desc)

    render json: books
  end

  # POST /api/books
  def create
    title = params.require(:title)

    book = current_user.books.create!(title: title)

    render json: book, status: 201
  end

  # PATCH /api/books/:id
  def update
    book_id = params.require(:id)

    book = current_user.books.find(book_id)

    attrs = {
      title: params[:title]
    }.compact

    book.update!(attrs) if attrs.present?

    render json: book
  end

  # DELETE /api/books/:id
  def destroy
    book_id = params.require(:id)

    current_user.books.find(book_id).destroy!

    head 204
  end

  # POST /api/books/import
  def import
    file    = params.require(:file)
    col_sep = params.require(:col_sep)

    book = nil

    ActiveRecord::Base.transaction do
      book = current_user.books.create!(title: "Book_#{Time.current.strftime('%Y%m%d%H%M%S')}")
      Page.import!(BookTranslator.from_csv(file, col_sep, book))
    end

    render json: book
  end

  # POST /api/books/:id/export
  def export
    book_id = params.require(:id)

    book = current_user.books.find(book_id)

    csv_data = BookTranslator.to_csv(book)

    send_data csv_data, type: 'text/csv'
  end

  # PATCH /api/books/positions
  def positions
    book_ids = JSON.parse(params.require(:book_ids))

    BookArranger.arrange!(current_user, book_ids)

    head 200
  end
end
