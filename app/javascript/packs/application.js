import Vue from "vue";
import Vuex from "vuex";
import VueRouter from "vue-router";
import store from "../store/index";
import router from "../routes";
import App from "../app.vue";

Vue.use(Vuex);
Vue.use(VueRouter);

document.addEventListener("DOMContentLoaded", () => {
  new Vue({
    el: "#application",
    store: new Vuex.Store(store),
    router,
    render: h => h(App)
  });
});
