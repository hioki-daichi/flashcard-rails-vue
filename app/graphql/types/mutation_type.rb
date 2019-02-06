module Types
  class MutationType < Types::BaseObject
    field :deleteBook, mutation: Mutations::DeleteBook
    field :updateBook, mutation: Mutations::UpdateBook
    field :createBook, mutation: Mutations::CreateBook
  end
end
