import Vue from "vue";
import VueRouter from "vue-router";
import Login from "./components/Login.vue";
import BookIndex from "./components/BookIndex.vue";
import PageIndex from "./components/PageIndex.vue";
import store from "./store/index";

Vue.use(VueRouter);

const router = new VueRouter({
  routes: [
    {
      path: "/",
      redirect: "/books"
    },
    {
      path: "/login",
      component: Login,
      meta: {
        skipAuth: true
      }
    },
    {
      path: "/books",
      component: BookIndex
    },
    {
      path: "/books/:bookSub",
      name: "bookDetail",
      component: PageIndex,
      props: true
    }
  ]
});

router.beforeEach((to, from, next) => {
  if (!to.meta.skipAuth && !store.state.auth.jwt) {
    alert("Login required");
    store.commit("global/setPreviousUrl", to.path);
    next({ path: "/login" });
  } else {
    next();
  }
});

export default router;
