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
      return axios
        .post("/api/books", { title: state.newBook.title })
        .then(res => {
          commit("addBook", res.data);
          commit("updateNewBook", { title: "" });
        });
    },
    updateBook({ state, commit }) {
      return axios
        .patch(`/api/books/${state.editingBook.id}`, {
          title: state.editingBook.title
        })
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
      const bookIds = state.books.map(book => {
        return book.id;
      });
      return axios.patch(`/api/books/positions`, {
        book_ids: JSON.stringify(bookIds)
      });
    },
    importBook({ state, commit }) {
      return axios
        .post(
          "/api/books/import",
          { file: state.selectedFile, col_sep: state.colSep },
          {
            headers: { "Content-Type": "multipart/form-data" }
          }
        )
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
