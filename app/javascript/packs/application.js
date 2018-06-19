import Vue from "vue";
import store from "../store/index";
import router from "../routes";
import App from "../app.vue";

document.addEventListener("DOMContentLoaded", () => {
  new Vue({
    el: "#application",
    store,
    router,
    render: h => h(App)
  });
});
