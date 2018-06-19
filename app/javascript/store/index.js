import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    books: []
  },
  mutations: {},
  actions: {
    fetchBooks({ state, commit }) {
      axios.get("/ajax/books").then(res => {
        state.books = res.data;
      }, alert);
    }
  }
});
