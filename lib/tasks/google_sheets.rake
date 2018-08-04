namespace :google_sheets do
  desc 'Import from Google sheets URL'
  task :import, %i(url email) => :environment do |_, args|
    url   = args[:url] or abort("url argument required")
    email = args[:email]

    user = email ? User.find_by!(email: email) : User.last

    title = "Book_#{Time.current.strftime('%Y%m%d%H%M%S')}"

    ActiveRecord::Base.transaction do
      OpenURI.open_uri(url) do |io|
        book = user.books.create!(title: title)

        html = Nokogiri::HTML.parse(io.read)

        html.search('br').each { |br| br.replace("\n") }

        html.css('#sheets-viewport table tbody tr').each.with_index do |tr, index|
          path, question, answer = tr.css('td').map(&:text)

          book.pages.create!(path: path, question: question, answer: answer, row_order: index)
        end
      end
    end
  end
end
