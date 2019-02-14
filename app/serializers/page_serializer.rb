class PageSerializer < ActiveModel::Serializer
  attributes :sub, :path, :question, :answer, :rowOrder

  def rowOrder
    object.row_order
  end
end
