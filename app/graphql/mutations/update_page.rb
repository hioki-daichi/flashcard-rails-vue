module Mutations
  class UpdatePage < GraphQL::Schema::RelayClassicMutation
    field :page, Types::PageType, null: true
    field :errors, [String], null: false

    argument :book_sub, ID, required: true
    argument :page_sub, ID, required: true
    argument :path, String, required: false
    argument :question, String, required: false
    argument :answer, String, required: false

    def resolve(book_sub:, page_sub:, path: nil, question: nil, answer: nil)
      book = current_user.books.find_by(sub: book_sub)

      unless book
        return {page: nil, errors: ["book not found"]}
      end

      page = book.pages.find_by(sub: page_sub)

      unless page
        return {page: nil, errors: ["page not found"]}
      end

      attrs = { path: path, question: question, answer: answer }.compact

      if attrs.empty?
        return {page: page, errors: []}
      end

      if page.update(attrs)
        {page: page, errors: []}
      else
        {page: page, errors: page.errors.full_messages}
      end
    end

    private

    def current_user
      context[:current_user]
    end
  end
end
