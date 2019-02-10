class Api::BooksController < ApplicationController
  # POST /api/books/import
  def import
    file = params.require(:file)
    col_sep = params.require(:col_sep)

    book = nil

    ActiveRecord::Base.transaction do
      book = current_user.books.create!(title: "Book_#{Time.current.strftime("%Y%m%d%H%M%S")}")
      Page.import!(BookTranslator.from_csv(file, col_sep, book))
    end

    render json: book
  end

  # POST /api/books/:book_sub/export
  def export
    book_sub = params.require(:book_sub)

    book = current_user.books.find_by!(sub: book_sub)

    csv_data = BookTranslator.to_csv(book)

    send_data csv_data, type: "text/csv"
  end
end
