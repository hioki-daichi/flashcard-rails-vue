import axios from "../axios";
import mutator from "../mutator";

export default {
  namespaced: true,
  state: {
    list: [],
    id: null,
    newIndex: null,
    newObject: {
      path: "",
      question: "",
      answer: ""
    },
    editing: null
  },
  mutations: {
    setList: mutator.set("list"),
    add: mutator.pushTo("list"),
    replace: mutator.replaceById("list"),
    setId: mutator.set("id"),
    setNewIndex: mutator.set("newIndex"),
    updateNewObject: mutator.assign("newObject"),
    setEditing: mutator.set("editing"),
    remove: mutator.omitById("list")
  },
  actions: {
    create({ state, commit, rootState }) {
      return axios
        .post(`/api/books/${rootState.book.id}/pages`, {
          path: state.newObject.path,
          question: state.newObject.question,
          answer: state.newObject.answer
        })
        .then(res => {
          commit("add", res.data);
          commit("updateNewObject", { path: "", question: "", answer: "" });
        });
    },
    update({ state, commit, rootState }) {
      return axios
        .patch(`/api/books/${rootState.book.id}/pages/${state.editing.id}`, {
          path: state.editing.path,
          question: state.editing.question,
          answer: state.editing.answer
        })
        .then(res => {
          commit("replace", res.data);
          commit("setEditing", null);
        });
    },
    fetch({ state, commit, rootState }) {
      const f = (state, commit, sinceId) => {
        const basePath = `/api/books/${rootState.book.id}/pages`;
        const path = sinceId ? `${basePath}?since_id=${sinceId}` : basePath;
        axios.get(path).then(res => {
          commit("setList", state.list.concat(res.data.pages));
          const nextId = res.data.meta.next_id;
          if (nextId) {
            f(state, commit, nextId);
          }
        });
      };
      f(state, commit, null);
    },
    destroy({ state, commit, rootState }) {
      return axios
        .delete(`/api/books/${rootState.book.id}/pages/${state.id}`)
        .then(res => {
          commit("remove", state.id);
        });
    },
    sort({ state, commit, rootState }) {
      return axios.patch(
        `/api/books/${rootState.book.id}/pages/${state.id}/sort`,
        { row_order_position: state.newIndex }
      );
    }
  }
};
