class PageSerializer < ActiveModel::Serializer
  attributes :id, :path, :question, :answer
end
