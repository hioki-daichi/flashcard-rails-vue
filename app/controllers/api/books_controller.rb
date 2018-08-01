class Api::BooksController < ApplicationController
  # GET /api/books
  def index
    books = current_user.books.rank(:row_order)

    render json: books
  end

  # POST /api/books
  def create
    title = params.require(:title)

    book = current_user.books.create!(title: title)

    render json: book, status: 201
  end

  # PATCH /api/books/:book_sub
  def update
    book_sub = params.require(:book_sub)

    book = current_user.books.find_by!(sub: book_sub)

    attrs = {
      title: params[:title]
    }.compact

    book.update!(attrs) if attrs.present?

    render json: book
  end

  # DELETE /api/books/:book_sub
  def destroy
    book_sub = params.require(:book_sub)

    current_user.books.find_by!(sub: book_sub).destroy!

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

  # POST /api/books/:book_sub/export
  def export
    book_sub = params.require(:book_sub)

    book = current_user.books.find_by!(sub: book_sub)

    csv_data = BookTranslator.to_csv(book)

    send_data csv_data, type: 'text/csv'
  end

  # PATCH /api/books/:book_sub/sort
  def sort
    book_sub           = params.require(:book_sub)
    row_order_position = params.require(:row_order_position)

    book = current_user.books.find_by!(sub: book_sub)

    book.update!(row_order_position: row_order_position)

    head 200
  end
end
