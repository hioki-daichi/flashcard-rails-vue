class PageArranger
  def self.arrange!(book, page_ids)
    ActiveRecord::Base.transaction do
      book.pages.each do |page|
        position = page_ids.index(page.id)
        page.update!(position: position)
      end
    end
  end
end
