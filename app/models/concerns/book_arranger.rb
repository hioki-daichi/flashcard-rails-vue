class BookArranger
  def self.arrange!(user, book_ids)
    ActiveRecord::Base.transaction do
      user.books.each do |book|
        position = book_ids.index(book.id)
        book.update!(position: position)
      end
    end
  end
end
