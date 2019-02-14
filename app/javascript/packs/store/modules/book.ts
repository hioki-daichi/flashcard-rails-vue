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
        .post("/graphql", { query: `mutation { createBook(input: { title: "${state.newObject.title}" }) { book { sub title rowOrder } errors } }` })
        .then(res => {
          const { book, errors } = res.data.data.createBook;
          if (errors.length === 0) {
            commit("add", book);
            commit("updateNewObject", { title: "" });
          } else {
            alert(errors);
          }
        });
    },
    update({ state, commit }) {
      return axios
        .post("/graphql", { query: `mutation { updateBook(input: { sub: "${state.editing.sub}", title: "${state.editing.title}" }) { book { sub title rowOrder } errors } }` })
        .then(res => {
          const { book, errors } = res.data.data.updateBook;
          if (errors.length === 0) {
            commit("replace", book);
            commit("setEditing", null);
          } else {
            alert(errors);
          }
        });
    },
    fetch({ state, commit }) {
      return axios.post("/graphql", { query: "query { books { sub title rowOrder }}" }).then(res => {
        commit("setList", res.data.data.books);
      });
    },
    destroy({ state, commit }) {
      return axios
        .post("/graphql", { query: `mutation { deleteBook(input: { sub: "${state.sub}" }) { book { sub } errors } }` })
        .then(res => {
          const { book, errors } = res.data.data.deleteBook;
          if (errors.length === 0) {
            commit("remove", book.sub);
          } else {
            alert(errors);
          }
        });
    },
    sort({ state, commit }) {
      return axios
        .post("/graphql", { query: `mutation { sortBooks(input: { sub: "${state.sub}", rowOrderPosition: ${state.newIndex} }) { book { sub title rowOrder } errors } }` })
        .then(res => {
          const { book, errors } = res.data.data.sortBooks;
          if (errors.length == 0) {
            commit("replace", book);
          } else {
            alert(errors);
          }
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
