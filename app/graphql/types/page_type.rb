module Types
  class PageType < Types::BaseObject
    field :sub, ID, null: false
    field :path, String, null: false
    field :question, String, null: false
    field :answer, String, null: false
    field :row_order, Int, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
