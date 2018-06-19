import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    books: [],
    currentBookId: null,
    pages: []
  },
  mutations: {
    setCurrentBookId(state, bookId) {
      state.currentBookId = bookId;
    }
  },
  actions: {
    fetchBooks({ state, commit }) {
      axios.get("/ajax/books").then(res => {
        state.books = res.data;
      }, alert);
    },
    fetchPages({ state, commit }) {
      axios
        .get("/ajax/books/" + this.state.currentBookId.toString() + "/pages")
        .then(res => {
          state.pages = res.data;
        }, alert);
    }
  }
});
