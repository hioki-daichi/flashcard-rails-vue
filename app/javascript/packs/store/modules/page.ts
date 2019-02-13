import axios from "../axios";
import mutator from "../mutator";

export default {
  namespaced: true,
  state: {
    list: [],
    sub: null,
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
    replace: mutator.replaceBySub("list"),
    setSub: mutator.set("sub"),
    setNewIndex: mutator.set("newIndex"),
    updateNewObject: mutator.assign("newObject"),
    setEditing: mutator.set("editing"),
    remove: mutator.omitBySub("list")
  },
  actions: {
    create({ state, commit, rootState }) {
      return axios
        .post("/graphql", { query: `mutation { createPage(input: { bookSub: "${rootState.book.sub}", path: "${state.newObject.path}", question: "${state.newObject.question}", answer: ${state.newObject.answer} }) { page { sub path question answer } errors } }` })
        .then(res => {
          const { page, errors } = res.data.data.createPage;
          if (errors.length === 0) {
            commit("add", page);
            commit("updateNewObject", { path: "", question: "", answer: "" });
          } else {
            alert(errors);
          }
        });
    },
    update({ state, commit, rootState }) {
      return axios
        .post("/graphql", { query: `mutation { updatePage(input: { bookSub: "${rootState.book.sub}", pageSub: "${state.editing.sub}", path: "${state.editing.path}", question: "${state.editing.question}", answer: ${state.editing.answer} }) { page { sub path question answer } errors } }` })
        .then(res => {
          const { page, errors } = res.data.data.updatePage;
          if (errors.length === 0) {
            commit("replace", page);
            commit("setEditing", null);
          } else {
            alert(errors);
          }
        });
    },
    fetch({ state, commit, rootState }) {
      const f = (state, commit, sinceSub) => {
        const basePath = `/api/books/${rootState.book.sub}/pages`;
        const path = sinceSub ? `${basePath}?since_sub=${sinceSub}` : basePath;
        axios.get(path).then(res => {
          commit("setList", state.list.concat(res.data.pages));
          const nextSub = res.data.meta.next_sub;
          if (nextSub) {
            f(state, commit, nextSub);
          }
        });
      };
      f(state, commit, null);
    },
    destroy({ state, commit, rootState }) {
      return axios
        .delete(`/api/books/${rootState.book.sub}/pages/${state.sub}`)
        .then(res => {
          commit("remove", state.sub);
        });
    },
    sort({ state, commit, rootState }) {
      return axios.patch(
        `/api/books/${rootState.book.sub}/pages/${state.sub}/sort`,
        { row_order_position: state.newIndex }
      );
    }
  }
};
