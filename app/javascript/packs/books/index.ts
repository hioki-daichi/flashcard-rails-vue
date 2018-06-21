import Vue from "vue";
import BookIndex from "../components/BookIndex.vue";

document.addEventListener("DOMContentLoaded", () => {
  new Vue(BookIndex).$mount("#app");
});
