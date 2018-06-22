class Ajax::BooksController < ApplicationController
  def create
    title = params[:title]
    book = Book.create!(title: title)
    render json: book
  end

  def index
    books = Book.all
    render json: books
  end
end
