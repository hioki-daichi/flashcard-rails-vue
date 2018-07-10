import axios from "../axios";
import mutator from "../mutator";

export default {
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
    setBooks: mutator.set("books"),
    addBook: mutator.unshiftTo("books"),
    replaceBook: mutator.replaceById("books"),
    setBookId: mutator.set("bookId"),
    updateNewBook: mutator.assign("newBook"),
    setEditingBook: mutator.set("editingBook"),
    removeBook: mutator.omitById("books"),
    setSelectedFile: mutator.set("selectedFile"),
    setColSep: mutator.set("colSep")
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
