import Vue from "vue";
import Vuex from "vuex";
import axios from "./axios";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    jwt: localStorage.getItem("flashcard:user-token"),
    loginForm: {
      email: null,
      password: null
    },
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
    editingPage: null,
    selectedFile: null
  },
  mutations: {
    setJWT(state, value) {
      state.jwt = value;
      if (value) {
        localStorage.setItem("flashcard:user-token", value);
      } else {
        localStorage.removeItem("flashcard:user-token");
      }
    },
    updateLoginForm(state, value) {
      state.loginForm = Object.assign(state.loginForm, value);
    },
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
    setPages(state, value) {
      state.pages = value;
    },
    addPage(state, value) {
      state.pages.push(value);
    },
    replacePage(state, value) {
      state.pages = state.pages.map(page => {
        if (page.id == value.id) {
          return value;
        } else {
          return page;
        }
      });
    },
    setPageId(state, value) {
      state.pageId = value;
    },
    updateNewPage(state, value) {
      state.newPage = Object.assign(state.newPage, value);
    },
    setEditingPage(state, value) {
      state.editingPage = value;
    },
    removePage(state, value) {
      state.pages = state.pages.filter(page => {
        return page.id != value;
      });
    },
    setSelectedFile(state, value) {
      state.selectedFile = value;
    }
  },
  actions: {
    authenticate({ state, commit }) {
      const data = new FormData();
      data.append("email", state.loginForm.email);
      data.append("password", state.loginForm.password);
      return axios.post("/api/auth", data).then(res => {
        commit("setJWT", res.data.token);
      });
    },
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
          commit("setEditingBook", null);
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
    exportBook({ state, commit }) {
      return axios
        .get(`/api/books/${state.bookId}/export`, { responseType: "blob" })
        .then(res => {
          const link = document.createElement("a");
          link.href = window.URL.createObjectURL(new Blob([res.data]));
          link.download = `book${state.bookId}.csv`;
          link.click();
        });
    },
    createPage({ state, commit }) {
      const data = new FormData();
      data.append("question", state.newPage.question);
      data.append("answer", state.newPage.answer);
      return axios.post(`/api/books/${state.bookId}/pages`, data).then(res => {
        commit("addPage", res.data);
        commit("updateNewPage", { question: "", answer: "" });
      });
    },
    updatePage({ state, commit }) {
      const data = new FormData();
      data.append("question", state.editingPage.question);
      data.append("answer", state.editingPage.answer);
      return axios
        .patch(`/api/books/${state.bookId}/pages/${state.editingPage.id}`, data)
        .then(res => {
          commit("replacePage", res.data);
          commit("setEditingPage", null);
        });
    },
    fetchPages({ state, commit }) {
      return axios.get(`/api/books/${state.bookId}/pages`).then(res => {
        commit("setPages", res.data);
      });
    },
    destroyPage({ state, commit }) {
      return axios
        .delete(`/api/books/${state.bookId}/pages/${state.pageId}`)
        .then(res => {
          commit("removePage", state.pageId);
        });
    },
    updateBookPositions({ state, commit }) {
      const data = new FormData();
      const bookIds = state.books.map(book => {
        return book.id;
      });
      data.append("book_ids", JSON.stringify(bookIds));
      return axios.patch(`/api/books/positions`, data);
    },
    updatePagePositions({ state, commit }) {
      const data = new FormData();
      const pageIds = state.pages.map(page => {
        return page.id;
      });
      data.append("page_ids", JSON.stringify(pageIds));
      return axios.patch(`/api/books/${state.bookId}/page_positions`, data);
    },
    importBook({ state, commit }) {
      const data = new FormData();
      data.append("file", state.selectedFile);
      return axios
        .post("/api/books/import", data, {
          headers: { "Content-Type": "multipart/form-data" }
        })
        .then(res => {
          commit("addBook", res.data);
        });
    }
  }
});
