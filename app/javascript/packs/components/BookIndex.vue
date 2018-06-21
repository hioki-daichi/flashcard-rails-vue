<template>
  <div>
    <h2>Books</h2>
    <div class="flex-grid" v-for="book in this.$store.state.books">
      <div class="col"><router-link :to="{ name: 'bookPages', params: { bookId: book.id } }">{{ book.title }}</router-link></div>
    </div>
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

<style scoped>
.flex-grid {
  display: flex;
}
.col {
  flex: 1;
}
</style>
