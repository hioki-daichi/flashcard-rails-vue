import Vue from "vue";
import Vuetify from "vuetify";
import store from "./store/index";
import router from "./routes";
import App from "./app.vue";

import "vuetify/dist/vuetify.min.css";
import "material-design-icons/iconfont/material-icons.css";

Vue.use(Vuetify);

Vue.config.productionTip = false;

document.addEventListener("DOMContentLoaded", () => {
  new Vue({
    el: "#application",
    store,
    router,
    render: h => h(App)
  });
});
