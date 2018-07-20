class Api::PagesController < ApplicationController
  # GET /api/books/:book_id/pages
  def index
    book_id = params.require(:book_id)

    pages = current_user.books.find(book_id).pages.order(row_order: :asc, created_at: :asc, id: :asc)

    render json: pages
  end

  # POST /api/books/:book_id/pages
  def create
    book_id  = params.require(:book_id)
    path     = params[:path]
    question = params.require(:question)
    answer   = params.require(:answer)

    page = current_user.books.find(book_id).pages.create!(path: path, question: question, answer: answer)

    render json: page, status: 201
  end

  # PATCH /api/books/:book_id/pages/:id
  def update
    book_id = params.require(:book_id)
    page_id = params.require(:id)

    page = current_user.books.find(book_id).pages.find(page_id)

    attrs = {
      path:     params[:path],
      question: params[:question],
      answer:   params[:answer]
    }.compact

    page.update!(attrs) if attrs.present?

    render json: page
  end

  # DELETE /api/books/:book_id/pages/:id
  def destroy
    book_id = params.require(:book_id)
    page_id = params.require(:id)

    current_user.books.find(book_id).pages.find(page_id).destroy!

    head 204
  end

  # PATCH /api/books/:book_id/pages/positions
  def positions
    book_id = params.require(:book_id)

    book = current_user.books.find(book_id)

    page_ids = JSON.parse(params.require(:page_ids))

    PageArranger.arrange!(book, page_ids)

    head 200
  end
end
