import Vue from "vue";
import Vuex from "vuex";
import axios from "./axios";
import mutator from "./mutator";

import global from "./modules/global";
import auth from "./modules/auth";
import book from "./modules/book";
import page from "./modules/page";

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    global,
    auth,
    book,
    page
  }
});
