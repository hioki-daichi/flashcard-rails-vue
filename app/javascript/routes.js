import VueRouter from "vue-router";
import BookIndex from "./components/BookIndex.vue";
import PageIndex from "./components/PageIndex.vue";

const routes = [
  {
    path: "/",
    redirect: '/books'
  },
  {
    path: "/books",
    component: BookIndex
  },
  {
    path: "/books/:bookId/pages",
    name: "bookPages",
    component: PageIndex,
    props: true
  }
];

export default new VueRouter({ routes });
