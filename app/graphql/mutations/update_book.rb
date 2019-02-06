module Mutations
  class UpdateBook < GraphQL::Schema::RelayClassicMutation
    field :book,   Types::BookType, null: true
    field :errors, [String],        null: false

    argument :sub,   ID,     required: true
    argument :title, String, required: false

    def resolve(sub:, title:)
      book = current_user.books.find_by(sub: sub)

      unless book
        return { book: nil, errors: ['record not found'] }
      end

      if book.update(title: title)
        { book: book, errors: [] }
      else
        { book: nil, errors: book.errors.full_messages }
      end
    end

    private

    def current_user
      context[:current_user]
    end
  end
end
