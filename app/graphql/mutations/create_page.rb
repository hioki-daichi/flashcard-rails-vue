module Mutations
  class CreatePage < GraphQL::Schema::RelayClassicMutation
    field :page, Types::PageType, null: true
    field :errors, [String], null: false

    argument :book_sub, ID, required: true
    argument :path, String, required: false
    argument :question, String, required: true
    argument :answer, String, required: true

    def resolve(book_sub:, path:, question:, answer:)
      book = current_user.books.find_by(sub: book_sub)

      unless book
        return {page: nil, errors: ["record not found"]}
      end

      page = book.pages.build(path: path, question: question, answer: answer)

      if page.save
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
