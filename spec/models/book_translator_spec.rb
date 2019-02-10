require "rails_helper"

RSpec.describe BookTranslator, type: :model do
  describe ".to_csv" do
    subject { BookTranslator.to_csv(book) }

    let!(:book) { create(:book) }
    let!(:page_1) { create(:page, book: book, path: "Path 1", question: "Question 1", answer: "Answer 1") }
    let!(:page_2) { create(:page, book: book, path: "Path 2", question: "Question 2", answer: "Answer 2") }

    it { is_expected.to eq "Path 1,Question 1,Answer 1\nPath 2,Question 2,Answer 2\n" }
  end

  describe ".from_csv" do
    subject(:pages) { BookTranslator.from_csv(file, "comma", book) }

    let(:file) { file_fixture("book.csv").open }
    let!(:book) { create(:book) }

    it "builds pages from CSV file" do
      expect(pages[0].path).to eq "Path 1"
      expect(pages[0].question).to eq "Question 1"
      expect(pages[0].answer).to eq "Answer 1"
      expect(pages[1].path).to eq "Path 2"
      expect(pages[1].question).to eq "Question 2"
      expect(pages[1].answer).to eq "Answer 2"
    end
  end
end
