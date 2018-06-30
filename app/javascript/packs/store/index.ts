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
    editingBook: null,
    pages: [],
    pageId: null,
    newPage: {
      question: "",
      answer: ""
    },
    editingPage: null
  },
  mutations: {
    setBooks(state, value) {
      state.books = value;
    },
    addBook(state, value) {
      state.books.unshift(value);
    },
    replaceBook(state, value) {
      state.books = state.books.map(book => {
        if (book.id == value.id) {
          return value;
        } else {
          return book;
        }
      });
    },
    setBookId(state, value) {
      state.bookId = value;
    },
    updateNewBook(state, value) {
      state.newBook = Object.assign(state.newBook, value);
    },
    setEditingBook(state, value) {
      state.editingBook = value;
    },
    removeBook(state, value) {
      state.books = state.books.filter(book => {
        return book.id != value;
      });
    },
    setPageId(state, value) {
      state.pageId = value;
    },
    updateNewPageQuestion(state, value) {
      state.newPage.question = value;
    },
    updateNewPageAnswer(state, value) {
      state.newPage.answer = value;
    },
    setEditingPage(state, value) {
      state.editingPage = value;
    }
  },
  actions: {
    createBook({ state, commit }) {
      const data = new FormData();
      data.append("title", state.newBook.title);
      return axios.post("/api/books", data).then(res => {
        commit("addBook", res.data);
        commit("updateNewBook", { title: "" });
      });
    },
    updateBook({ state, commit }) {
      const data = new FormData();
      data.append("title", state.editingBook.title);
      return axios
        .patch(`/api/books/${state.editingBook.id}`, data)
        .then(res => {
          commit("replaceBook", res.data);
        });
    },
    fetchBooks({ state, commit }) {
      return axios.get("/api/books").then(res => {
        commit("setBooks", res.data);
      });
    },
    destroyBook({ state, commit }) {
      return axios.delete(`/api/books/${state.bookId}`).then(_ => {
        commit("removeBook", state.bookId);
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
      data.append("question", state.editingPage.question);
      data.append("answer", state.editingPage.answer);
      return axios
        .patch(`/api/books/${state.bookId}/pages/${state.editingPage.id}`, data)
        .then(res => {
          state.pages = state.pages.map(page => {
            if (page.id == res.data.id) {
              return res.data;
            } else {
              return page;
            }
          });
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
