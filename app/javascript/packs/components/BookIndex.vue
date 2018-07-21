<template>
  <div>
    <h2>Books</h2>
    <div>
      <input type="text" placeholder="Title" v-model="newBookTitle" />
      <button @click="submit">Submit</button>
    </div>
    <draggable :options="{ handle: '.handle' }" @end="onEnd">
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
    this.$store.dispatch("book/fetch");
  },
  destroyed() {
    this.$store.commit("book/setList", []);
  },
  computed: {
    books() {
      return this.$store.state.book.list;
    },
    newBookTitle: {
      get() {
        return this.$store.state.book.newObject.title;
      },
      set(value) {
        this.$store.commit("book/updateNewObject", { title: value });
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
    onEnd(e) {
      this.$store.commit("book/setId", this.books[e.oldIndex].id);
      this.$store.commit("book/setNewIndex", e.newIndex);
      this.$store.dispatch("book/sort");
    },
    submit() {
      this.$store.dispatch("book/create");
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
