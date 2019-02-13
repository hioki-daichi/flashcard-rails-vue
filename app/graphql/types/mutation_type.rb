module Types
  class MutationType < Types::BaseObject
    field :updatePage, mutation: Mutations::UpdatePage
    field :createPage, mutation: Mutations::CreatePage
    field :sortBooks, mutation: Mutations::SortBooks
    field :deleteBook, mutation: Mutations::DeleteBook
    field :updateBook, mutation: Mutations::UpdateBook
    field :createBook, mutation: Mutations::CreateBook
  end
end
