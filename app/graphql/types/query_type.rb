module Types
  class QueryType < Types::BaseObject
    field :books, [BookType], null: false

    field :book, BookType, null: true do
      argument :sub, ID, required: true
    end

    def books
      current_user.books.rank(:row_order)
    end

    def book(sub:)
      current_user.books.find_by(sub: sub)
    end

    private

    def current_user
      context[:current_user]
    end
  end
end
