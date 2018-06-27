<template>
  <div>
    <h2>Books</h2>
    <div>
      <input type="text" placeholder="Title" v-model="newBookTitle" />
      <button @click="submit">Submit</button>
    </div>
    <Book v-for="book in this.$store.state.books" :book="book" :key="book.id"></Book>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import Book from "./Book.vue";

export default Vue.extend({
  components: {
    Book
  },
  created() {
    this.$store.dispatch("fetchBooks");
  },
  computed: {
    newBookTitle: {
      get() {
        return this.$store.state.newBook.title;
      },
      set(value) {
        this.$store.commit("updateNewBookTitle", value);
      }
    }
  },
  methods: {
    submit() {
      this.$store.dispatch("createBook");
    }
  }
});
</script>
