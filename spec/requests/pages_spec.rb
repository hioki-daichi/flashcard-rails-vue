require 'rails_helper'

RSpec.describe Api::PagesController, type: :request do
  let!(:user) { create(:user) }
  let(:headers) { { Authorization: "Bearer: #{JsonWebToken.encode(user_id: user.id)}" } }

  let!(:book) { create(:book, user: user) }

  subject(:body) { JSON.parse(response.body) }

  describe 'GET /api/books/:book_id/pages' do
    let(:path) { "/api/books/#{book.id}/pages" }

    context 'when Authorization header is not specified' do
      it 'returns authorization header required error' do
        get path
        expect(response).to have_http_status 400
        expect(body['errors']).to eq ['Authorization header required']
      end
    end

    context 'when Authorization header is specified' do
      context 'when nonexistent book id is specified' do
        let(:path) { "/api/books/0/pages" }

        it 'returns http status 404 and not found error' do
          get path, headers: headers
          expect(response).to have_http_status 404
          expect(body['errors']).to eq ['Resource not found']
        end
      end

      context 'when there is no page' do
        it 'returns http status 200 and empty array' do
          get path, headers: headers
          expect(response).to have_http_status 200
          expect(body).to eq []
        end
      end

      context 'when there are 3 pages with different positions' do
        let!(:page_1) { create(:page, book: book, position: 1) }
        let!(:page_2) { create(:page, book: book, position: 2) }
        let!(:page_3) { create(:page, book: book, position: 0) }

        it 'returns position asc-ordered pages' do
          get path, headers: headers
          expect(body[0]['id']).to be page_3.id
          expect(body[1]['id']).to be page_1.id
          expect(body[2]['id']).to be page_2.id
        end
      end

      context 'when there are 3 pages with same position and different created_at' do
        let!(:page_1) { create(:page, book: book, position: 0) }
        let!(:page_2) { create(:page, book: book, position: 0) }
        let!(:page_3) { create(:page, book: book, position: 0) }

        before do
          now = Time.current
          page_1.update_column(:created_at, now + 1)
          page_2.update_column(:created_at, now + 3)
          page_3.update_column(:created_at, now + 2)
        end

        it 'returns created_at asc-ordered pages' do
          get path, headers: headers
          expect(body[0]['id']).to be page_1.id
          expect(body[1]['id']).to be page_3.id
          expect(body[2]['id']).to be page_2.id
        end
      end

      context 'when there are 3 pages with same position and created_at' do
        let!(:page_1) { create(:page, book: book, position: 0) }
        let!(:page_2) { create(:page, book: book, position: 0) }
        let!(:page_3) { create(:page, book: book, position: 0) }

        before do
          now = Time.current
          page_1.update_column(:created_at, now)
          page_2.update_column(:created_at, now)
          page_3.update_column(:created_at, now)
        end

        it 'returns id asc-ordered pages' do
          get path, headers: headers
          expect(body[0]['id']).to be page_1.id
          expect(body[1]['id']).to be page_2.id
          expect(body[2]['id']).to be page_3.id
        end
      end
    end
  end

  describe 'POST /api/books/:book_id/pages' do
    let(:path) { "/api/books/#{book.id}/pages" }
    let(:path_param) { 'Path 1' }
    let(:question) { 'Question 1' }
    let(:answer) { 'Answer 1' }

    describe 'path' do
      context 'when path param is not specified' do
        it 'returns http status 201 and created page and increases number of pages' do
          expect {
            post path, params: { question: question, answer: answer }, headers: headers
          }.to change { book.pages.count }.by(1)
          expect(response).to have_http_status 201
          expect(body.keys).to contain_exactly('id', 'path', 'question', 'answer')
          expect(body['path']).to be nil
          expect(body['question']).to eq 'Question 1'
          expect(body['answer']).to eq 'Answer 1'
        end
      end

      context 'when path param is specified' do
        let(:params) { { path: path_param, question: question, answer: answer } }

        it 'returns path set page' do
          post path, params: params, headers: headers
          expect(body['path']).to eq 'Path 1'
        end

        context 'when path has 256 characters' do
          let(:path_param) { 'a' * 256 }

          it 'returns maximum length error' do
            post path, params: params, headers: headers
            expect(response).to have_http_status 400
            expect(body['errors']).to eq ['Path is too long (maximum is 255 characters)']
          end
        end
      end
    end

    describe 'question' do
      context 'when question param is not specified' do
        it 'returns parameter missing error' do
          expect {
            post path, params: { path: path_param, answer: answer }, headers: headers
          }.not_to change { book.pages.count }
          expect(response).to have_http_status 400
          expect(body['errors']).to eq ["param is missing or the value is empty: question"]
        end
      end

      context 'when question has 1001 characters' do
        let(:question) { 'a' * 1001 }

        it 'returns maximum length error' do
          post path, params: { path: path_param, question: question, answer: answer }, headers: headers
          expect(response).to have_http_status 400
          expect(body['errors']).to eq ['Question is too long (maximum is 1000 characters)']
        end
      end
    end

    describe 'answer' do
      context 'when answer param is not specified' do
        it 'returns parameter missing error' do
          expect {
            post path, params: { path: path_param, question: question }, headers: headers
          }.not_to change { book.pages.count }
          expect(response).to have_http_status 400
          expect(body['errors']).to eq ["param is missing or the value is empty: answer"]
        end
      end

      context 'when answer has 1001 characters' do
        let(:answer) { 'a' * 1001 }

        it 'returns maximum length error' do
          post path, params: { path: path_param, question: question, answer: answer }, headers: headers
          expect(response).to have_http_status 400
          expect(body['errors']).to eq ['Answer is too long (maximum is 1000 characters)']
        end
      end
    end
  end

  describe 'PATCH /api/books/:book_id/pages/:id' do
    let(:path) { "/api/books/#{book.id}/pages/#{page.id}" }
    let!(:page) { create(:page, book: book, path: 'Path 1', question: 'Question 1', answer: 'Answer 1') }

    context 'when params are not specified' do
      it 'returns http status 200 and existing page' do
        expect {
          patch path, headers: headers
        }.not_to change { book.pages.count }
        expect(response).to have_http_status 200
        expect(body.keys).to contain_exactly('id', 'path', 'question', 'answer')
        expect(body['id']).to be page.id
        expect(body['path']).to eq page.path
        expect(body['question']).to eq page.question
        expect(body['answer']).to eq page.answer
      end
    end

    context 'when params are specified' do
      it 'returns http status 200 and updated page' do
        expect {
          patch path, params: { path: 'Path 2', question: 'Question 2', answer: 'Answer 2' }, headers: headers
        }.not_to change { book.pages.count }
        expect(response).to have_http_status 200
        expect(body.keys).to contain_exactly('id', 'path', 'question', 'answer')
        expect(body['id']).to be page.id
        expect(body['path']).to eq 'Path 2'
        expect(body['question']).to eq 'Question 2'
        expect(body['answer']).to eq 'Answer 2'
      end
    end
  end

  describe 'DELETE /api/books/:book_id/pages/:id' do
    let(:path) { "/api/books/#{book.id}/pages/#{page.id}" }
    let!(:page) { create(:page, book: book) }

    it 'returns http status 204 and decreases number of pages' do
      expect {
        delete path, headers: headers
      }.to change { book.pages.count }.by(-1)
      expect(response).to have_http_status 204
      expect(response.body).to eq ''
    end
  end

  describe 'PATCH /api/books/:book_id/pages/positions' do
    let(:path) { "/api/books/#{book.id}/pages/positions" }

    let!(:page_1) { create(:page, book: book, position: 0) }
    let!(:page_2) { create(:page, book: book, position: 1) }
    let!(:page_3) { create(:page, book: book, position: 2) }

    it 'arranges page positions' do
      patch path, params: { page_ids: "[#{page_2.id},#{page_3.id},#{page_1.id}]" }, headers: headers
      expect(page_1.reload.position).to be 2
      expect(page_2.reload.position).to be 0
      expect(page_3.reload.position).to be 1
      expect(response).to have_http_status 200
    end
  end
end
