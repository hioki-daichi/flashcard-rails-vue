require 'rails_helper'

RSpec.describe Api::BooksController, type: :request do
  let!(:user) { create(:user) }
  let(:headers) { { Authorization: "Bearer: #{JsonWebToken.encode(user_id: user.id)}" } }

  subject(:body) { JSON.parse(response.body) }

  describe 'GET /api/books' do
    let(:path) { '/api/books' }

    context 'when Authorization header is not specified' do
      it 'returns authorization header required error' do
        get path
        expect(response).to have_http_status 400
        expect(body['errors']).to eq ['Authorization header required']
      end
    end

    context 'when Authorization header is specified' do
      context 'when there is no book' do
        it 'returns http status 200 and empty array' do
          get path, headers: headers
          expect(response).to have_http_status 200
          expect(body).to eq []
        end
      end

      context 'when there are 3 books with different row_orders' do
        let!(:book_1) { create(:book, user: user, row_order: 1) }
        let!(:book_2) { create(:book, user: user, row_order: 2) }
        let!(:book_3) { create(:book, user: user, row_order: 0) }

        it 'returns row_order asc-ordered books' do
          get path, headers: headers
          expect(body[0]['id']).to be book_3.id
          expect(body[1]['id']).to be book_1.id
          expect(body[2]['id']).to be book_2.id
        end
      end
    end
  end

  describe 'POST /api/books' do
    let(:path) { '/api/books' }

    context 'when title param is not specified' do
      it 'returns parameter missing error' do
        post path, headers: headers
        expect(response).to have_http_status 400
        expect(body['errors']).to eq ["param is missing or the value is empty: title"]
      end
    end

    context 'when title param is specified' do
      let(:params) { { title: title } }

      context 'when title is "foo"' do
        let(:title) { "foo" }

        it 'returns http status 201 and created book and increases number of books' do
          expect {
            post path, params: params, headers: headers
          }.to change { user.books.count }.by(1)
          expect(response).to have_http_status 201
          expect(body.keys).to contain_exactly('id', 'title')
          expect(body['id']).to be_a Integer
          expect(body['title']).to eq title
        end
      end

      context 'when title has 256 characters' do
        let(:title) { 'a' * 256 }

        it 'returns maximum length error' do
          post path, params: params, headers: headers
          expect(response).to have_http_status 400
          expect(body['errors']).to eq ['Title is too long (maximum is 255 characters)']
        end
      end
    end
  end

  describe 'PATCH /api/books/:id' do
    let(:path) { "/api/books/#{book.id}" }
    let!(:book) { create(:book, user: user) }

    context 'when params are not specified' do
      it 'returns http status 200 and updated book' do
        expect {
          patch path, headers: headers
        }.not_to change { user.books.count }
        expect(response).to have_http_status 200
        expect(body.keys).to contain_exactly('id', 'title')
        expect(body['id']).to be book.id
        expect(body['title']).to eq book.title
      end
    end
  end

  describe 'DELETE /api/books/:id' do
    let(:path) { "/api/books/#{book.id}" }
    let!(:book) { create(:book, user: user) }

    it 'returns http status 204 and decreases number of books' do
      expect {
        delete path, headers: headers
      }.to change { user.books.count }.by(-1)
      expect(response).to have_http_status 204
      expect(response.body).to eq ''
    end
  end

  describe 'POST /api/books/import' do
    let(:path) { '/api/books/import' }
    let(:file) { Rack::Test::UploadedFile.new(file_fixture('book.csv')) }
    let(:col_sep) { 'comma' }

    context 'when file param is not specified' do
      it 'returns parameter missing error' do
        post path, params: { col_sep: col_sep }, headers: headers
        expect(response).to have_http_status 400
        expect(body['errors']).to eq ['param is missing or the value is empty: file']
      end
    end

    context 'when col_sep param is not specified' do
      it 'returns parameter missing error' do
        post path, params: { file: file }, headers: headers
        expect(response).to have_http_status 400
        expect(body['errors']).to eq ['param is missing or the value is empty: col_sep']
      end
    end

    context 'when file and col_sep are specified' do
      around { |e| travel_to(Time.zone.local(2020, 7, 24, 23, 59, 59)) { e.run } }

      it 'returns http status 200 and imported book and increases number of books' do
        expect {
          post path, params: { file: file, col_sep: col_sep }, headers: headers
        }.to change { user.books.count }.by(1)
        expect(response).to have_http_status 200
        expect(body.keys).to contain_exactly('id', 'title')
        expect(body['id']).to be_a Integer
        expect(body['title']).to eq 'Book_20200724235959'
      end
    end

    context 'when tsv file and "tab" are specified' do
      let(:file) { Rack::Test::UploadedFile.new(file_fixture('book.tsv')) }
      let(:col_sep) { 'tab' }

      around { |e| travel_to(Time.zone.local(2020, 7, 24, 23, 59, 59)) { e.run } }

      it 'returns http status 200 and imported book and increases number of books' do
        expect {
          post path, params: { file: file, col_sep: col_sep }, headers: headers
        }.to change { user.books.count }.by(1)
        expect(response).to have_http_status 200
        expect(body.keys).to contain_exactly('id', 'title')
        expect(body['id']).to be_a Integer
        expect(body['title']).to eq 'Book_20200724235959'
      end
    end
  end

  describe 'GET /api/books/:id/export' do
    let(:path) { "/api/books/#{book.id}/export" }
    let!(:book) { create(:book, user: user) }

    before do
      create(:page, book: book, path: 'Path1', question: 'Q1', answer: 'A1')
      create(:page, book: book, path: 'Path2', question: 'Q2', answer: 'A2')
    end

    it 'exports books' do
      get path, headers: headers
      expect(response).to have_http_status 200
      expect(response.headers['Content-Type']).to eq 'text/csv'
      expect(response.body).to eq "Path1,Q1,A1\nPath2,Q2,A2\n"
    end
  end

  describe 'PATCH /api/books/:id/sort' do
    let(:path) { "/api/books/#{book_id}/sort" }

    let!(:book_1) { create(:book, user: user, row_order: 0) }
    let!(:book_2) { create(:book, user: user, row_order: 1) }
    let!(:book_3) { create(:book, user: user, row_order: 2) }

    def book_1_order; book_1.reload.row_order end
    def book_2_order; book_2.reload.row_order end
    def book_3_order; book_3.reload.row_order end

    let(:params) { { row_order_position: row_order_position } }

    context 'when 3rd item is dropped at the beginning' do
      let(:book_id) { book_3.id }
      let(:row_order_position) { 0 }

      it 'updates to 3 < 1 < 2' do
        patch path, params: params, headers: headers
        expect(response).to have_http_status 200
        expect(book_3_order).to be < book_1_order
        expect(book_1_order).to be < book_2_order
      end
    end

    context 'when 2nd item is dropped at the end' do
      let(:book_id) { book_2.id }
      let(:row_order_position) { 2 }

      it 'updates to 1 < 3 < 2' do
        patch path, params: params, headers: headers
        expect(response).to have_http_status 200
        expect(book_1_order).to be < book_3_order
        expect(book_3_order).to be < book_2_order
      end
    end

    context 'when first item is dropped at the end' do
      let(:book_id) { book_1.id }
      let(:row_order_position) { 2 }

      it 'updates to 2 < 3 < 1' do
        patch path, params: params, headers: headers
        expect(response).to have_http_status 200
        expect(book_2_order).to be < book_3_order
        expect(book_3_order).to be < book_1_order
      end
    end
  end
end
