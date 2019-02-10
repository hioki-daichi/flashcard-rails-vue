module Mutations
  class CreateBook < GraphQL::Schema::RelayClassicMutation
    field :book, Types::BookType, null: true
    field :errors, [String], null: false

    argument :title, String, required: true

    def resolve(title:)
      book = current_user.books.build(title: title)
      if book.save
        {book: book, errors: []}
      else
        {book: nil, errors: book.errors.full_messages}
      end
    end

    private

    def current_user
      context[:current_user]
    end
  end
end
