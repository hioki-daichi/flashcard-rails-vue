import Vue from "vue";
import Vuex from "vuex";
import axios from "./axios";
import {
  set,
  assign,
  replaceById,
  omitById,
  unshiftTo,
  pushTo
} from "./stateMutator";

Vue.use(Vuex);

const global = {
  namespaced: true,
  state: {
    previousUrl: null,
    loading: false
  },
  mutations: {
    setPreviousUrl: set("previousUrl"),
    setLoading: set("loading")
  }
};

const auth = {
  namespaced: true,
  state: {
    jwt: localStorage.getItem("flashcard:user-token"),
    loginForm: {
      email: null,
      password: null
    }
  },
  mutations: {
    setJWT(state, value) {
      state.jwt = value;
      if (value) {
        localStorage.setItem("flashcard:user-token", value);
      } else {
        localStorage.removeItem("flashcard:user-token");
      }
    },
    updateLoginForm: assign("loginForm")
  },
  actions: {
    authenticate({ state, commit }) {
      const data = new FormData();
      data.append("email", state.loginForm.email);
      data.append("password", state.loginForm.password);
      return axios.post("/api/auth", data).then(res => {
        commit("setJWT", res.data.token);
      });
    }
  }
};

const book = {
  namespaced: true,
  state: {
    books: [],
    bookId: null,
    newBook: {
      title: ""
    },
    editingBook: null,
    selectedFile: null,
    colSep: "comma"
  },
  mutations: {
    setBooks: set("books"),
    addBook: unshiftTo("books"),
    replaceBook: replaceById("books"),
    setBookId: set("bookId"),
    updateNewBook: assign("newBook"),
    setEditingBook: set("editingBook"),
    removeBook: omitById("books"),
    setSelectedFile: set("selectedFile"),
    setColSep: set("colSep")
  },
  actions: {
    createBook({ state, commit }) {
      const data = new FormData();
      data.append("title", state.newBook.title);
      return axios.post("/api/books", data).then(res => {
        commit("addBook", res.data);
        commit("updateNewBook", { title: "" });
      });
    },
    updateBook({ state, commit }) {
      const data = new FormData();
      data.append("title", state.editingBook.title);
      return axios
        .patch(`/api/books/${state.editingBook.id}`, data)
        .then(res => {
          commit("replaceBook", res.data);
          commit("setEditingBook", null);
        });
    },
    fetchBooks({ state, commit }) {
      return axios.get("/api/books").then(res => {
        commit("setBooks", res.data);
      });
    },
    destroyBook({ state, commit }) {
      return axios.delete(`/api/books/${state.bookId}`).then(_ => {
        commit("removeBook", state.bookId);
      });
    },
    updateBookPositions({ state, commit }) {
      const data = new FormData();
      const bookIds = state.books.map(book => {
        return book.id;
      });
      data.append("book_ids", JSON.stringify(bookIds));
      return axios.patch(`/api/books/positions`, data);
    },
    importBook({ state, commit }) {
      const data = new FormData();
      data.append("file", state.selectedFile);
      data.append("col_sep", state.colSep);
      return axios
        .post("/api/books/import", data, {
          headers: { "Content-Type": "multipart/form-data" }
        })
        .then(res => {
          commit("addBook", res.data);
        });
    },
    exportBook({ state, commit }) {
      return axios
        .get(`/api/books/${state.bookId}/export`, { responseType: "blob" })
        .then(res => {
          const link = document.createElement("a");
          link.href = window.URL.createObjectURL(new Blob([res.data]));
          link.download = `book${state.bookId}.csv`;
          link.click();
        });
    }
  }
};

const page = {
  namespaced: true,
  state: {
    pages: [],
    pageId: null,
    newPage: {
      path: "",
      question: "",
      answer: ""
    },
    editingPage: null
  },
  mutations: {
    setPages: set("pages"),
    addPage: pushTo("pages"),
    replacePage: replaceById("pages"),
    setPageId: set("pageId"),
    updateNewPage: assign("newPage"),
    setEditingPage: set("editingPage"),
    removePage: omitById("pages")
  },
  actions: {
    createPage({ state, commit, rootState }) {
      const data = new FormData();
      data.append("path", state.newPage.path);
      data.append("question", state.newPage.question);
      data.append("answer", state.newPage.answer);
      return axios
        .post(`/api/books/${rootState.book.bookId}/pages`, data)
        .then(res => {
          commit("addPage", res.data);
          commit("updateNewPage", { path: "", question: "", answer: "" });
        });
    },
    updatePage({ state, commit, rootState }) {
      const data = new FormData();
      data.append("path", state.editingPage.path);
      data.append("question", state.editingPage.question);
      data.append("answer", state.editingPage.answer);
      return axios
        .patch(
          `/api/books/${rootState.book.bookId}/pages/${state.editingPage.id}`,
          data
        )
        .then(res => {
          commit("replacePage", res.data);
          commit("setEditingPage", null);
        });
    },
    fetchPages({ state, commit, rootState }) {
      return axios
        .get(`/api/books/${rootState.book.bookId}/pages`)
        .then(res => {
          commit("setPages", res.data);
        });
    },
    destroyPage({ state, commit, rootState }) {
      return axios
        .delete(`/api/books/${rootState.book.bookId}/pages/${state.pageId}`)
        .then(res => {
          commit("removePage", state.pageId);
        });
    },
    updatePagePositions({ state, commit, rootState }) {
      const data = new FormData();
      const pageIds = state.pages.map(page => {
        return page.id;
      });
      data.append("page_ids", JSON.stringify(pageIds));
      return axios.patch(
        `/api/books/${rootState.book.bookId}/pages/positions`,
        data
      );
    }
  }
};

export default new Vuex.Store({
  modules: {
    global,
    auth,
    book,
    page
  }
});
