import VueRouter from "vue-router";
import WelcomePage from "./components/shared/welcome.vue";
import BookIndex from "./components/BookIndex.vue";
import PageIndex from "./components/PageIndex.vue";

const routes = [
  {
    path: "/",
    component: WelcomePage
  },
  {
    path: "/books",
    component: BookIndex
  },
  {
    path: "/books/:bookId/pages",
    component: PageIndex,
    props: true
  }
];

export default new VueRouter({ routes });
