namespace :dummy do
  task pages: :environment do
    require Rails.root.join('spec', 'factories', 'pages.rb')

    book_id   = ENV['BOOK_ID']&.to_i   || Book.maximum(:id)
    num_pages = ENV['NUM_PAGES']&.to_i || 100

    FactoryBot.create_list(:page, num_pages, book_id: book_id)
  end
end
