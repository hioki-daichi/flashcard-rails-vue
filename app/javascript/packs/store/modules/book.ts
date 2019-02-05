import axios from "../axios";
import mutator from "../mutator";

export default {
  namespaced: true,
  state: {
    list: [],
    sub: null,
    newIndex: null,
    newObject: {
      title: ""
    },
    editing: null,
    selectedFile: null,
    colSep: "comma"
  },
  mutations: {
    setList: mutator.set("list"),
    add: mutator.pushTo("list"),
    replace: mutator.replaceBySub("list"),
    setSub: mutator.set("sub"),
    setNewIndex: mutator.set("newIndex"),
    updateNewObject: mutator.assign("newObject"),
    setEditing: mutator.set("editing"),
    remove: mutator.omitBySub("list"),
    setSelectedFile: mutator.set("selectedFile"),
    setColSep: mutator.set("colSep")
  },
  actions: {
    create({ state, commit }) {
      return axios
        .post("/api/books", { title: state.newObject.title })
        .then(res => {
          commit("add", res.data);
          commit("updateNewObject", { title: "" });
        });
    },
    update({ state, commit }) {
      return axios
        .patch(`/api/books/${state.editing.sub}`, {
          title: state.editing.title
        })
        .then(res => {
          commit("replace", res.data);
          commit("setEditing", null);
        });
    },
    fetch({ state, commit }) {
      return axios.post("/graphql", { query: "query { books { sub title }}" }).then(res => {
        commit("setList", res.data.data.books);
      });
    },
    destroy({ state, commit }) {
      return axios.delete(`/api/books/${state.sub}`).then(_ => {
        commit("remove", state.sub);
      });
    },
    sort({ state, commit }) {
      return axios.patch(`/api/books/${state.sub}/sort`, {
        row_order_position: state.newIndex
      });
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
          commit("add", res.data);
        });
    },
    exportBook({ state, commit }) {
      return axios
        .get(`/api/books/${state.sub}/export`, { responseType: "blob" })
        .then(res => {
          const link = document.createElement("a");
          link.href = window.URL.createObjectURL(new Blob([res.data]));
          link.download = `book${state.sub}.csv`;
          link.click();
        });
    }
  }
};
