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
      return axios
        .post(`/api/books/${rootState.book.bookId}/pages`, {
          path: state.newPage.path,
          question: state.newPage.question,
          answer: state.newPage.answer
        })
        .then(res => {
          commit("addPage", res.data);
          commit("updateNewPage", { path: "", question: "", answer: "" });
        });
    },
    updatePage({ state, commit, rootState }) {
      return axios
        .patch(
          `/api/books/${rootState.book.bookId}/pages/${state.editingPage.id}`,
          {
            path: state.editingPage.path,
            question: state.editingPage.question,
            answer: state.editingPage.answer
          }
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
      const pageIds = state.pages.map(page => {
        return page.id;
      });
      return axios.patch(
        `/api/books/${rootState.book.bookId}/pages/positions`,
        { page_ids: JSON.stringify(pageIds) }
      );
    }
  }
};
