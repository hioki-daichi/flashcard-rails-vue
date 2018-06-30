# frozen_string_literal: true
require 'csv'

class BookTranslator
  HEADER = %w(question answer)

  def self.to_csv(book)
    rows = book.pages.order(id: :asc).map { |page| page.attributes.values_at(*HEADER) }

    CSV.generate do |csv|
      rows.each do |row|
        csv << row
      end
    end
  end
end
