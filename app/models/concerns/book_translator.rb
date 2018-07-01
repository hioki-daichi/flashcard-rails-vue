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

  def self.from_csv(file, col_sep, book)
    text = file.read
    rows = CSV.parse(text, col_sep: COL_SEPS[col_sep])
    rows.map { |row| book.pages.new(Hash[HEADER.zip(row)]) }
  end
end
