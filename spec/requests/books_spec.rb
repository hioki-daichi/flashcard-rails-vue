require "rails_helper"

RSpec.describe Api::BooksController, type: :request do
  let!(:user) { create(:user) }
  let(:headers) { { Authorization: "Bearer: #{JsonWebToken.encode(user_id: user.id)}" } }

  subject(:body) { JSON.parse(response.body) }

  describe "query { books { sub title } }" do
    let(:path) { "/graphql" }
    let(:query) { "query { books { sub title } }" }

    context "when Authorization header is not specified" do
      it "returns authorization header required error" do
        post path, params: { query: query }
        expect(response).to have_http_status 400
        expect(body["errors"]).to eq ["Authorization header required"]
      end
    end

    context "when Authorization header is specified" do
      context "when there is no book" do
        it "returns http status 200 and empty array" do
          post path, params: { query: query }, headers: headers
          expect(response).to have_http_status 200
          expect(response.body).to be_json(data: {books: []})
        end
      end

      context "when there are 3 books with different row_orders" do
        let!(:book_1) { create(:book, user: user, row_order: 1) }
        let!(:book_2) { create(:book, user: user, row_order: 2) }
        let!(:book_3) { create(:book, user: user, row_order: 0) }

        it "returns row_order asc-ordered books" do
          post path, params: { query: query }, headers: headers
          expect(response.body).to be_json(
            data: {
              books: [
                {sub: book_3.sub, title: String},
                {sub: book_1.sub, title: String},
                {sub: book_2.sub, title: String},
              ],
            },
          )
        end
      end
    end
  end

  describe "mutation { createBook(input: { title: $title }) { book { sub title } errors } }" do
    let(:path) { "/graphql" }
    let(:query) { "mutation { createBook(input: { title: \"#{title}\" }) { book { sub title } errors } }" }

    context 'when title is ""' do
      let(:title) { "" }

      it "returns \"Title can't be blank\"" do
        post path, params: { query: query }, headers: headers
        expect(response).to have_http_status 200
        expect(body.dig("data", "createBook", "errors")).to eq ["Title can't be blank"]
      end
    end

    context 'when title is "foo"' do
      let(:title) { "foo" }

      it "returns created book and increases number of books" do
        expect {
          post path, params: { query: query }, headers: headers
        }.to change { user.books.count }.by(1)
        expect(response).to have_http_status 200
        expect(body.dig("data", "createBook", "book", "sub")).to be_a String
        expect(body.dig("data", "createBook", "book", "title")).to eq title
      end
    end

    context "when title has 256 characters" do
      let(:title) { "a" * 256 }

      it 'returns "Title is too long (maximum is 255 characters)"' do
        post path, params: { query: query }, headers: headers
        expect(response).to have_http_status 200
        expect(body.dig("data", "createBook", "errors")).to eq ["Title is too long (maximum is 255 characters)"]
      end
    end
  end

  describe "mutation { updateBook(input: { sub: $sub, title: $title }) { book { sub title } errors } }" do
    let!(:book) { create(:book, user: user, title: "Title A") }
    let(:path) { "/graphql" }
    let(:query) { "mutation { updateBook(input: { sub: \"#{book.sub}\", title: \"#{title}\" }) { book { sub title } errors } }" }

    context 'when title is "Title B"' do
      let(:title) { "Title B" }

      it "returns http status 200 and updated book" do
        expect {
          post path, params: { query: query }, headers: headers
        }.not_to change { user.books.count }
        expect(response).to have_http_status 200
        expect(body.dig("data", "updateBook", "book", "sub")).to eq book.sub
        expect(body.dig("data", "updateBook", "book", "title")).to eq title
      end
    end

    context 'when title is ""' do
      let(:title) { "" }

      it "returns \"Title can't be blank\"" do
        post path, params: { query: query }, headers: headers
        expect(response).to have_http_status 200
        expect(body.dig("data", "updateBook", "errors")).to eq ["Title can't be blank"]
      end
    end

    context "when title has 256 characters" do
      let(:title) { "a" * 256 }

      it 'returns "Title is too long (maximum is 255 characters)"' do
        post path, params: { query: query }, headers: headers
        expect(response).to have_http_status 200
        expect(body.dig("data", "updateBook", "errors")).to eq ["Title is too long (maximum is 255 characters)"]
      end
    end
  end

  describe "mutation { deleteBook(input: { sub: $sub }) { book { sub } errors } }" do
    let!(:book) { create(:book, user: user) }
    let(:path) { "/graphql" }
    let(:query) { "mutation { deleteBook(input: { sub: \"#{book.sub}\" }) { book { sub } errors } }" }

    it "decreases number of books" do
      expect {
        post path, params: { query: query }, headers: headers
      }.to change { user.books.count }.by(-1)
      expect(response).to have_http_status 200
      expect(body.dig("data", "deleteBook", "book", "sub")).to eq book.sub
    end
  end

  describe "POST /api/books/import" do
    let(:path) { "/api/books/import" }
    let(:file) { Rack::Test::UploadedFile.new(file_fixture("book.csv")) }
    let(:col_sep) { "comma" }

    context "when file param is not specified" do
      it "returns parameter missing error" do
        post path, params: { col_sep: col_sep }, headers: headers
        expect(response).to have_http_status 400
        expect(body["errors"]).to eq ["param is missing or the value is empty: file"]
      end
    end

    context "when col_sep param is not specified" do
      it "returns parameter missing error" do
        post path, params: { file: file }, headers: headers
        expect(response).to have_http_status 400
        expect(body["errors"]).to eq ["param is missing or the value is empty: col_sep"]
      end
    end

    context "when file and col_sep are specified" do
      around { |e| travel_to(Time.zone.local(2020, 7, 24, 23, 59, 59)) { e.run } }

      it "returns http status 200 and imported book and increases number of books" do
        expect {
          post path, params: { file: file, col_sep: col_sep }, headers: headers
        }.to change { user.books.count }.by(1)
        expect(response).to have_http_status 200
        expect(body.keys).to contain_exactly("sub", "title")
        expect(body["sub"]).to be_a String
        expect(body["title"]).to eq "Book_20200724235959"
      end
    end

    context 'when tsv file and "tab" are specified' do
      let(:file) { Rack::Test::UploadedFile.new(file_fixture("book.tsv")) }
      let(:col_sep) { "tab" }

      around { |e| travel_to(Time.zone.local(2020, 7, 24, 23, 59, 59)) { e.run } }

      it "returns http status 200 and imported book and increases number of books" do
        expect {
          post path, params: { file: file, col_sep: col_sep }, headers: headers
        }.to change { user.books.count }.by(1)
        expect(response).to have_http_status 200
        expect(body.keys).to contain_exactly("sub", "title")
        expect(body["sub"]).to be_a String
        expect(body["title"]).to eq "Book_20200724235959"
      end
    end
  end

  describe "GET /api/books/:sub/export" do
    let(:path) { "/api/books/#{book.sub}/export" }
    let!(:book) { create(:book, user: user) }

    before do
      create(:page, book: book, path: "Path1", question: "Q1", answer: "A1")
      create(:page, book: book, path: "Path2", question: "Q2", answer: "A2")
    end

    it "exports books" do
      get path, headers: headers
      expect(response).to have_http_status 200
      expect(response.headers["Content-Type"]).to eq "text/csv"
      expect(response.body).to eq "Path1,Q1,A1\nPath2,Q2,A2\n"
    end
  end

  describe "mutation { sortBooks(input: { sub: $sub, rowOrderPosition: $rowOrderPosition }) { book { sub } errors } }" do
    let(:path) { "/graphql" }
    let(:query) { "mutation { sortBooks(input: { sub: \"#{sub}\", rowOrderPosition: #{row_order_position} }) { book { sub } errors } }" }

    let!(:book_1) { create(:book, user: user, row_order: 0) }
    let!(:book_2) { create(:book, user: user, row_order: 1) }
    let!(:book_3) { create(:book, user: user, row_order: 2) }

    def book_1_order; book_1.reload.row_order end
    def book_2_order; book_2.reload.row_order end
    def book_3_order; book_3.reload.row_order end

    context "when 3rd item is dropped at the beginning" do
      let(:sub) { book_3.sub }
      let(:row_order_position) { 0 }

      it "updates to 3 < 1 < 2" do
        post path, params: { query: query }, headers: headers
        expect(response).to have_http_status 200
        expect(book_3_order).to be < book_1_order
        expect(book_1_order).to be < book_2_order
      end
    end

    context "when 2nd item is dropped at the end" do
      let(:sub) { book_2.sub }
      let(:row_order_position) { 2 }

      it "updates to 1 < 3 < 2" do
        post path, params: { query: query }, headers: headers
        expect(response).to have_http_status 200
        expect(book_1_order).to be < book_3_order
        expect(book_3_order).to be < book_2_order
      end
    end

    context "when first item is dropped at the end" do
      let(:sub) { book_1.sub }
      let(:row_order_position) { 2 }

      it "updates to 2 < 3 < 1" do
        post path, params: { query: query }, headers: headers
        expect(response).to have_http_status 200
        expect(book_2_order).to be < book_3_order
        expect(book_3_order).to be < book_1_order
      end
    end
  end
end
