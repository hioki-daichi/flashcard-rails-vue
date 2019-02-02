module Types
  class BookType < Types::BaseObject
    field :sub,        ID,                              null: false
    field :title,      String,                          null: false
    field :pages,      [Types::PageType],               null: false
    field :row_order,  Int,                             null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
