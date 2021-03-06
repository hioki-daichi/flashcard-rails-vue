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
end
