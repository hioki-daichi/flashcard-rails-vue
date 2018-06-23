<template>
  <div>
    <h2>Books</h2>
    <div class="flex-grid">
      <div class="col">
        <input type="text" placeholder="Title" v-model="title" />
        <button @click="submit">Submit</button>
      </div>
    </div>
    <div class="flex-grid" v-for="book in this.$store.state.books">
      <div class="col">
        <router-link :to="{ name: 'bookPages', params: { bookId: book.id } }">{{ book.title }}</router-link>
        <button @click="destroy(book)">Delete</button>
      </div>
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
    title: {
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

<style scoped>
.flex-grid {
  display: flex;
}
.col {
  flex: 1;
}
</style>
