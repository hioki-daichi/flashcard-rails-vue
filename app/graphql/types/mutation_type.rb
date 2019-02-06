module Types
  class MutationType < Types::BaseObject
    field :updateBook, mutation: Mutations::UpdateBook
    field :createBook, mutation: Mutations::CreateBook
  end
end
