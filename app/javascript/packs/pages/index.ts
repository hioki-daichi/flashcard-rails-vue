import Vue from "vue";
import PageIndex from "../../src/components/PageIndex.vue";

document.addEventListener("DOMContentLoaded", () => {
  new Vue(PageIndex).$mount("#app");
});
