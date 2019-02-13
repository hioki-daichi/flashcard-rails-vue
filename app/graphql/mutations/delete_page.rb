module Mutations
  class DeletePage < GraphQL::Schema::RelayClassicMutation
    field :page, Types::PageType, null: true
    field :errors, [String], null: false

    argument :book_sub, ID, required: true
    argument :page_sub, ID, required: true

    def resolve(book_sub:, page_sub:)
      book = current_user.books.find_by(sub: book_sub)

      unless book
        return {page: nil, errors: ["book not found"]}
      end

      page = book.pages.find_by(sub: page_sub)

      unless page
        return {page: nil, errors: ["page not found"]}
      end

      if page.destroy
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
