import Vue from "vue";
import PageIndex from "../components/PageIndex.vue";

document.addEventListener("DOMContentLoaded", () => {
  new Vue(PageIndex).$mount("#app");
});
