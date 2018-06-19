<template>
  <div>
    <h2>Books</h2>
    <ul>
      <li v-for="book in this.$store.state.books">
        <router-link :to="{ name: 'bookPages', params: { bookId: book.id } }">{{ book.title }}</router-link>
      </li>
    </ul>
  </div>
</template>

<script lang="ts">
import Vue from "vue";

export default Vue.extend({
  created() {
    this.$store.dispatch("fetchBooks");
  }
});
</script>
