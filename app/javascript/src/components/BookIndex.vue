<template>
  <div>
    <h2>Books</h2>
    <ul v-for="book in books">
      <li>{{ book.title }}</li>
    </ul>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'

interface Book {
  id: number
  title: string
}

export default Vue.extend({
  data: function() {
    return {
      books: [{ id: 1, title: "foo" }, { id: 2, title: "bar" }] as Book[]
    };
  }
});
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
