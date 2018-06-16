books = Book.create([
  { title: 'Title 1' },
  { title: 'Title 2' },
])

books.each do |book|
  Page.create([
    { book_id: book.id, question: "Question 1 of #{book.title}", answer: "Answer 1 of #{book.title}" },
    { book_id: book.id, question: "Question 2 of #{book.title}", answer: "Answer 2 of #{book.title}" },
  ])
end
