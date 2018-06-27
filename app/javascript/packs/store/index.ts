import Vue from "vue";
import Vuex from "vuex";
import axios from "./axios";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    books: [],
    bookId: null,
    newBook: {
      title: ""
    },
    updatingBook: null,
    pages: [],
    pageId: null,
    newPage: {
      question: "",
      answer: ""
    },
    updatingPage: null
  },
  mutations: {
    setBookId(state, value) {
      state.bookId = value;
    },
    updateNewBookTitle(state, value) {
      state.newBook.title = value;
    },
    setUpdatingBook(state, value) {
      state.updatingBook = value;
    },
    setUpdatingPage(state, value) {
      state.updatingPage = value;
    },
    setPageId(state, value) {
      state.pageId = value;
    },
    updateNewPageQuestion(state, value) {
      state.newPage.question = value;
    },
    updateNewPageAnswer(state, value) {
      state.newPage.answer = value;
    }
  },
  actions: {
    createBook({ state, commit }) {
      const data = new FormData();
      data.append("title", state.newBook.title);
      return axios.post("/api/books", data).then(res => {
        state.books.unshift(res.data);
        state.newBook.title = "";
      });
    },
    updateBook({ state, commit }) {
      const data = new FormData();
      data.append("title", state.updatingBook.title);
      return axios
        .patch(`/api/books/${state.updatingBook.id}`, data)
        .then(res => {
          state.books = state.books.map(book => {
            if (book.id == res.data.id) {
              return res.data;
            } else {
              return book;
            }
          });
          state.updatingBook = null;
        });
    },
    fetchBooks({ state, commit }) {
      return axios.get("/api/books").then(res => {
        state.books = res.data;
      });
    },
    destroyBook({ state, commit }) {
      return axios.delete(`/api/books/${state.bookId}`).then(res => {
        state.books = state.books.filter(book => {
          return book.id != state.bookId;
        });
      });
    },
    createPage({ state, commit }) {
      const data = new FormData();
      data.append("question", state.newPage.question);
      data.append("answer", state.newPage.answer);
      return axios.post(`/api/books/${state.bookId}/pages`, data).then(res => {
        state.pages.push(res.data);
        state.newPage.question = "";
        state.newPage.answer = "";
      });
    },
    updatePage({ state, commit }) {
      const data = new FormData();
      data.append("question", state.updatingPage.question);
      data.append("answer", state.updatingPage.answer);
      return axios
        .patch(
          `/api/books/${state.bookId}/pages/${state.updatingPage.id}`,
          data
        )
        .then(res => {
          state.pages = state.pages.map(page => {
            if (page.id == res.data.id) {
              return res.data;
            } else {
              return page;
            }
          });
          state.updatingPage = null;
        });
    },
    fetchPages({ state, commit }) {
      return axios
        .get("/api/books/" + this.state.bookId.toString() + "/pages")
        .then(res => {
          state.pages = res.data;
        });
    },
    destroyPage({ state, commit }) {
      return axios
        .delete(`/api/books/${state.bookId}/pages/${state.pageId}`)
        .then(res => {
          state.pages = state.pages.filter(page => {
            return page.id != state.pageId;
          });
        });
    }
  }
});
