# frozen_string_literal: true
require 'csv'

class BookTranslator
  HEADER = %w(path question answer)

  COL_SEPS = { comma: ',', tab: "\t" }.with_indifferent_access

  def self.to_csv(book)
    rows = book.pages.order(id: :asc).map { |page| page.attributes.values_at(*HEADER) }

    CSV.generate do |csv|
      rows.each do |row|
        csv << row
      end
    end
  end

  def self.from_csv(file, col_sep)
    pages = CSV.parse(file.read, col_sep: COL_SEPS[col_sep]).map { |cols| Page.new(Hash[HEADER.zip(cols)]) }
    title ="Book_#{Time.current.strftime('%Y%m%d%H%M%S')}"
    Book.new(title: title, pages: pages)
  end
end
