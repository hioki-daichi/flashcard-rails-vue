class BookArranger
  def self.arrange!(user, book_ids)
    ActiveRecord::Base.transaction do
      user.books.each do |book|
        row_order = book_ids.index(book.id)
        book.update!(row_order: row_order)
      end
    end
  end
end
