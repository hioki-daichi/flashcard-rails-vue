<template>
  <div>
    <h2>Books</h2>
    <div>
      <input type="text" placeholder="Title" v-model="newBookTitle" />
      <button @click="submit">Submit</button>
    </div>
    <div v-for="book in this.$store.state.books">
      <router-link :to="{ name: 'bookPages', params: { bookId: book.id } }">{{ book.title }}</router-link>
      <button @click="destroy(book)">Delete</button>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";

export default Vue.extend({
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
    },
    destroy(book) {
      this.$store.commit("setBookId", book.id);
      this.$store.dispatch("destroyBook");
    }
  }
});
</script>
