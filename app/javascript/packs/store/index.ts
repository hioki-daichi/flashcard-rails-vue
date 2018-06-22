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
    pages: []
  },
  mutations: {
    setBookId(state, bookId) {
      state.bookId = bookId;
    },
    updateNewBookTitle(state, value) {
      state.newBook.title = value;
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
    fetchPages({ state, commit }) {
      axios
        .get("/ajax/books/" + this.state.bookId.toString() + "/pages")
        .then(res => {
          state.pages = res.data;
        }, alert);
    }
  }
});
