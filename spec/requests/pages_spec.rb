require "rails_helper"

RSpec.describe Api::PagesController, type: :request do
  let!(:user) { create(:user) }
  let(:headers) { { Authorization: "Bearer: #{JsonWebToken.encode(user_id: user.id)}" } }

  let!(:book) { create(:book, user: user) }

  subject(:body) { JSON.parse(response.body) }

  describe "GET /api/books/:book_sub/pages" do
    let(:path) { "/api/books/#{book.sub}/pages" }

    context "when Authorization header is not specified" do
      it "returns authorization header required error" do
        get path
        expect(response).to have_http_status 400
        expect(body["errors"]).to eq ["Authorization header required"]
      end
    end

    context "when Authorization header is specified" do
      context "when nonexistent book id is specified" do
        let(:path) { "/api/books/0/pages" }

        it "returns http status 404 and not found error" do
          get path, headers: headers
          expect(response).to have_http_status 404
          expect(body["errors"]).to eq ["Resource not found"]
        end
      end

      context "when there is no page" do
        it "returns http status 200 and empty array" do
          get path, headers: headers
          expect(response).to have_http_status 200
          expect(body).to eq("pages" => [], "meta" => { "next_sub" => nil })
        end
      end

      context "when there are 3 pages with different row_orders" do
        let!(:page_1) { create(:page, book: book, row_order: 1) }
        let!(:page_2) { create(:page, book: book, row_order: 2) }
        let!(:page_3) { create(:page, book: book, row_order: 0) }

        it "returns page params: [:sub, :path, :question, :answer]" do
          get path, headers: headers
          expect(body["pages"][0].keys).to match_array(%w(sub path question answer))
        end

        it "returns row_order asc-ordered pages" do
          get path, headers: headers
          expect(body["pages"].size).to be 3
          expect(body["pages"][0]["sub"]).to eq page_3.sub
          expect(body["pages"][1]["sub"]).to eq page_1.sub
          expect(body["pages"][2]["sub"]).to eq page_2.sub
        end

        context "when query parameter :since_sub is specified" do
          let(:params) { {since_sub: page_1.sub} }

          it "returns books those row_order is greater than specified" do
            get path, params: params, headers: headers
            expect(body["pages"].size).to be 2
            expect(body["pages"][0]["sub"]).to eq page_1.sub
            expect(body["pages"][1]["sub"]).to eq page_2.sub
          end
        end
      end
    end
  end

  describe "mutation { createPage(input: { bookSub: $bookSub, path: $path, question: $question, answer: $answer }) { page { sub path question answer } errors } }" do
    let(:path) { "/graphql" }
    let(:query) { "mutation { createPage(input: { bookSub: \"#{book.sub}\", path: \"#{path_param}\", question: \"#{question}\", answer: \"#{answer}\" }) { page { sub path question answer } errors } }" }
    let(:path_param) { "Path 1" }
    let(:question) { "Question 1" }
    let(:answer) { "Answer 1" }

    describe "path" do
      context "when path param is not specified" do
        let(:path_param) { nil }

        it "creates a page" do
          expect {
            post path, params: { query: query }, headers: headers
          }.to change { book.pages.count }.by(1)
          expect(body.dig("data", "createPage", "page").keys).to contain_exactly("sub", "path", "question", "answer")
          expect(body.dig("data", "createPage", "page", "sub")).to be_a String
          expect(body.dig("data", "createPage", "page", "path")).to eq ""
          expect(body.dig("data", "createPage", "page", "question")).to eq "Question 1"
          expect(body.dig("data", "createPage", "page", "answer")).to eq "Answer 1"
        end
      end

      context "when path param is specified" do
        let(:path_param) { "Path 1" }

        it "returns path set page" do
          post path, params: { query: query }, headers: headers
          expect(body.dig("data", "createPage", "page", "path")).to eq "Path 1"
        end
      end

      context "when path has 256 characters" do
        let(:path_param) { "a" * 256 }

        it "returns maximum length error" do
          post path, params: { query: query }, headers: headers
          expect(body.dig("data", "createPage", "errors")).to eq ["Path is too long (maximum is 255 characters)"]
        end
      end
    end

    describe "question" do
      context "when question param is not specified" do
        let(:question) { "" }

        it "returns \"Question can't be blank\"" do
          expect {
            post path, params: { query: query }, headers: headers
          }.not_to change { book.pages.count }
          expect(body.dig("data", "createPage", "errors")).to eq ["Question can't be blank"]
        end
      end

      context "when question has 2049 characters" do
        let(:question) { "a" * 2049 }

        it "returns maximum length error" do
          expect {
            post path, params: { query: query }, headers: headers
          }.not_to change { book.pages.count }
          expect(body.dig("data", "createPage", "errors")).to eq ["Question is too long (maximum is 2048 characters)"]
        end
      end
    end

    describe "answer" do
      context "when answer param is not specified" do
        let(:answer) { "" }

        it "returns \"Answer can't be blank\"" do
          expect {
            post path, params: { query: query }, headers: headers
          }.not_to change { book.pages.count }
          expect(body.dig("data", "createPage", "errors")).to eq ["Answer can't be blank"]
        end
      end

      context "when answer has 2049 characters" do
        let(:answer) { "a" * 2049 }

        it "returns maximum length error" do
          expect {
            post path, params: { query: query }, headers: headers
          }.not_to change { book.pages.count }
          expect(body.dig("data", "createPage", "errors")).to eq ["Answer is too long (maximum is 2048 characters)"]
        end
      end
    end
  end

  describe "mutation { updatePage(input: { bookSub: $bookSub, pageSub: $pageSub, path: $path, question: $question, answer: $answer }) { page { sub path question answer } errors } }" do
    let!(:page) { create(:page, book: book, path: "Path 1", question: "Question 1", answer: "Answer 1") }

    let(:path) { "/graphql" }

    context "when params are not specified" do
      let(:query) { "mutation { updatePage(input: { bookSub: \"#{book.sub}\", pageSub: \"#{page.sub}\" }) { page { sub path question answer } errors } }" }

      it "returns http status 200 and existing page" do
        expect {
          post path, params: { query: query }, headers: headers
        }.not_to change { book.pages.count }
        expect(body.dig("data", "updatePage", "page").keys).to contain_exactly("sub", "path", "question", "answer")
        expect(body.dig("data", "updatePage", "page", "sub")).to eq page.sub
        expect(body.dig("data", "updatePage", "page", "path")).to eq page.path
        expect(body.dig("data", "updatePage", "page", "question")).to eq page.question
        expect(body.dig("data", "updatePage", "page", "answer")).to eq page.answer
      end
    end

    context "when params are specified" do
      let(:query) { "mutation { updatePage(input: { bookSub: \"#{book.sub}\", pageSub: \"#{page.sub}\", path: \"Path 2\", question: \"Question 2\", answer: \"Answer 2\" }) { page { sub path question answer } errors } }" }

      it "returns http status 200 and updated page" do
        expect {
          post path, params: { query: query }, headers: headers
        }.not_to change { book.pages.count }
        expect(body.dig("data", "updatePage", "page").keys).to contain_exactly("sub", "path", "question", "answer")
        expect(body.dig("data", "updatePage", "page", "sub")).to eq page.sub
        expect(body.dig("data", "updatePage", "page", "path")).to eq "Path 2"
        expect(body.dig("data", "updatePage", "page", "question")).to eq "Question 2"
        expect(body.dig("data", "updatePage", "page", "answer")).to eq "Answer 2"
      end
    end
  end

  describe "mutation { deletePage(input: { bookSub: $bookSub, pageSub: $pageSub }) { page { sub } errors } }" do
    let!(:book) { create(:book, user: user) }
    let!(:page) { create(:page, book: book) }
    let(:path) { "/graphql" }
    let(:query) { "mutation { deletePage(input: { bookSub: \"#{book.sub}\", pageSub: \"#{page.sub}\" }) { page { sub } errors } }" }

    it "decreases number of books" do
      expect {
        post path, params: { query: query }, headers: headers
      }.to change { book.pages.count }.by(-1)
      expect(body.dig("data", "deletePage", "page", "sub")).to eq page.sub
    end
  end

  describe "mutation { sortPages(input: { bookSub: $bookSub, pageSub: $pageSub, rowOrderPosition: $rowOrderPosition }) { page { sub } errors } }" do
    let(:path) { "/graphql" }
    let(:query) { "mutation { sortPages(input: { bookSub: \"#{book.sub}\", pageSub: \"#{sub}\", rowOrderPosition: #{row_order_position} }) { page { sub } errors } }" }

    let!(:page_1) { create(:page, book: book, row_order: 0) }
    let!(:page_2) { create(:page, book: book, row_order: 1) }
    let!(:page_3) { create(:page, book: book, row_order: 2) }

    def page_1_order; page_1.reload.row_order end
    def page_2_order; page_2.reload.row_order end
    def page_3_order; page_3.reload.row_order end

    context "when 3rd item is dropped at the beginning" do
      let(:sub) { page_3.sub }
      let(:row_order_position) { 0 }

      it "updates to 3 < 1 < 2" do
        post path, params: { query: query }, headers: headers
        expect(response).to have_http_status 200
        expect(page_3_order).to be < page_1_order
        expect(page_1_order).to be < page_2_order
      end
    end

    context "when 2nd item is dropped at the end" do
      let(:sub) { page_2.sub }
      let(:row_order_position) { 2 }

      it "updates to 1 < 3 < 2" do
        post path, params: { query: query }, headers: headers
        expect(response).to have_http_status 200
        expect(page_1_order).to be < page_3_order
        expect(page_3_order).to be < page_2_order
      end
    end

    context "when first item is dropped at the end" do
      let(:sub) { page_1.sub }
      let(:row_order_position) { 2 }

      it "updates to 2 < 3 < 1" do
        post path, params: { query: query }, headers: headers
        expect(response).to have_http_status 200
        expect(page_2_order).to be < page_3_order
        expect(page_3_order).to be < page_1_order
      end
    end
  end
end
