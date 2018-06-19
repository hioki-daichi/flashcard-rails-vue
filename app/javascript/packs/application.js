import Vue from "vue";
import VueRouter from "vue-router";
import store from "../store/index";
import router from "../routes";
import App from "../app.vue";

Vue.use(VueRouter);

document.addEventListener("DOMContentLoaded", () => {
  new Vue({
    el: "#application",
    store,
    router,
    render: h => h(App)
  });
});
