module Mutations
  class SortPages < GraphQL::Schema::RelayClassicMutation
    field :page, Types::PageType, null: true
    field :errors, [String], null: false

    argument :book_sub, ID, required: true
    argument :page_sub, ID, required: true
    argument :row_order_position, Integer, required: true

    def resolve(book_sub:, page_sub:, row_order_position:)
      book = current_user.books.find_by(sub: book_sub)

      unless book
        return {page: nil, errors: ["book not found"]}
      end

      page = book.pages.find_by(sub: page_sub)

      unless page_sub
        return {page: nil, errors: ["page not found"]}
      end

      if page.update(row_order_position: row_order_position)
        {page: page, errors: []}
      else
        {page: nil, errors: page.errors.full_messages}
      end
    end

    private

    def current_user
      context[:current_user]
    end
  end
end
