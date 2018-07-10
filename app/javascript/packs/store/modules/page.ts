import axios from "../axios";
import mutator from "../mutator";

export default {
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
    setPages: mutator.set("pages"),
    addPage: mutator.pushTo("pages"),
    replacePage: mutator.replaceById("pages"),
    setPageId: mutator.set("pageId"),
    updateNewPage: mutator.assign("newPage"),
    setEditingPage: mutator.set("editingPage"),
    removePage: mutator.omitById("pages")
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
