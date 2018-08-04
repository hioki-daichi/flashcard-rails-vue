class PageSerializer < ActiveModel::Serializer
  attributes :sub, :path, :question, :answer
end
