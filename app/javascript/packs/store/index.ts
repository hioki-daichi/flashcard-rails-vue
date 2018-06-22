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
    newPage: {
      question: "",
      answer: ""
    },
    pages: []
  },
  mutations: {
    setBookId(state, bookId) {
      state.bookId = bookId;
    },
    updateNewBookTitle(state, value) {
      state.newBook.title = value;
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
      axios.post("/ajax/books", data).then(res => {
        state.books.unshift(res.data);
        state.newBook.title = "";
      }, alert);
    },
    fetchBooks({ state, commit }) {
      axios.get("/ajax/books").then(res => {
        state.books = res.data;
      }, alert);
    },
    createPage({ state, commit }) {
      const data = new FormData();
      data.append("question", state.newPage.question);
      data.append("answer", state.newPage.answer);
      axios.post(`/ajax/books/${state.bookId}/pages`, data).then(res => {
        state.pages.push(res.data);
        state.newPage.question = "";
        state.newPage.answer = "";
      }, alert);
    },
    fetchPages({ state, commit }) {
      axios
        .get("/ajax/books/" + this.state.bookId.toString() + "/pages")
        .then(res => {
          state.pages = res.data;
        }, alert);
    }
  }
});
