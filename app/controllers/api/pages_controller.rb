class Api::PagesController < ApplicationController
  # GET /api/books/:book_sub/pages
  def index
    book_sub = params.require(:book_sub)
    since_sub = params[:since_sub]

    pages = current_user.books.find_by!(sub: book_sub).pages.rank(:row_order)

    if since_sub
      pages.where!("row_order >= ?", pages.find_by!(sub: since_sub).row_order)
    end

    pages.limit!(Settings.num_pages_per_request + 1)

    xs = pages.to_a
    page_array = xs.shift(Settings.num_pages_per_request)
    next_sub = xs[0]&.sub

    render json: {
      pages: ActiveModel::Serializer::CollectionSerializer.new(
        page_array,
        each_serializer: PageSerializer,
      ),
      meta: {
        next_sub: next_sub,
      },
    }
  end

  # POST /api/books/:book_sub/pages
  def create
    book_sub = params.require(:book_sub)
    path = params[:path]
    question = params.require(:question)
    answer = params.require(:answer)

    page = current_user.books.find_by!(sub: book_sub).pages.create!(path: path, question: question, answer: answer)

    render json: page, status: 201
  end

  # PATCH /api/books/:book_sub/pages/:page_sub
  def update
    book_sub = params.require(:book_sub)
    page_sub = params.require(:page_sub)

    page = current_user.books.find_by!(sub: book_sub).pages.find_by!(sub: page_sub)

    attrs = {
      path: params[:path],
      question: params[:question],
      answer: params[:answer],
    }.compact

    page.update!(attrs) if attrs.present?

    render json: page
  end

  # DELETE /api/books/:book_sub/pages/:page_sub
  def destroy
    book_sub = params.require(:book_sub)
    page_sub = params.require(:page_sub)

    current_user.books.find_by!(sub: book_sub).pages.find_by!(sub: page_sub).destroy!

    head 204
  end

  # PATCH /api/books/:book_sub/pages/:page_sub/sort
  def sort
    book_sub = params.require(:book_sub)
    page_sub = params.require(:page_sub)
    row_order_position = params.require(:row_order_position)

    page = current_user.books.find_by!(sub: book_sub).pages.find_by!(sub: page_sub)

    page.update!(row_order_position: row_order_position)

    head 200
  end
end
