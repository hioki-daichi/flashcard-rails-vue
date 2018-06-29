user = User.create(email: 'hiokidaichi@gmail.com')

books = user.books.create([
  { title: 'Title 1' },
  { title: 'Title 2' },
])

books.each do |book|
  book.pages.create([
    { question: "Question 1 of #{book.title}", answer: "Answer 1 of #{book.title}" },
    { question: "Question 2 of #{book.title}", answer: "Answer 2 of #{book.title}" },
  ])
end
