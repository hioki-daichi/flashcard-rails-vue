<template>
  <div>
    <h2>Books</h2>
    <div>
      <input type="text" placeholder="Title" v-model="newBookTitle" />
      <button @click="submit">Submit</button>
    </div>
    <draggable v-model="books" :options="{ handle: '.handle' }">
      <Book v-for="book in books" :book="book" :key="book.id"></Book>
    </draggable>
    <h3>Import</h3>
    <input type="file" @change="fileSelected" ref="fileInput" />
    <select v-model="colSep">
      <option value="comma">,</option>
      <option value="tab">\t</option>
    </select>
    <button @click="importBook">Upload</button>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import Book from "./Book.vue";
import draggable from "vuedraggable";

export default Vue.extend({
  components: {
    Book,
    draggable
  },
  created() {
    this.$store.dispatch("book/fetchBooks");
  },
  destroyed() {
    this.$store.commit("book/setBooks", []);
  },
  computed: {
    books: {
      get() {
        return this.$store.state.book.books;
      },
      set(value) {
        this.$store.commit("book/setBooks", value);
        this.$store.dispatch("book/updateBookPositions");
      }
    },
    newBookTitle: {
      get() {
        return this.$store.state.book.newBook.title;
      },
      set(value) {
        this.$store.commit("book/updateNewBook", { title: value });
      }
    },
    colSep: {
      get() {
        return this.$store.state.book.colSep;
      },
      set(value) {
        this.$store.commit("book/setColSep", value);
      }
    }
  },
  methods: {
    submit() {
      this.$store.dispatch("book/createBook");
    },
    fileSelected(e) {
      this.$store.commit("book/setSelectedFile", e.target.files[0]);
    },
    importBook() {
      this.$store.dispatch("book/importBook").then(_ => {
        this.$refs.fileInput.value = "";
      });
    }
  }
});
</script>
