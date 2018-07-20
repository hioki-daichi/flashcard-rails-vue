class PageArranger
  def self.arrange!(book, page_ids)
    ActiveRecord::Base.transaction do
      book.pages.each do |page|
        row_order = page_ids.index(page.id)
        page.update!(row_order: row_order)
      end
    end
  end
end
