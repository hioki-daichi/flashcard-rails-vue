<template>
  <div>
    <h2>Books</h2>
    <table>
      <tbody>
        <tr v-for="book in this.$store.state.books">
          <td><router-link :to="{ name: 'bookPages', params: { bookId: book.id } }">{{ book.title }}</router-link></td>
        </tr>
      </tbody>
    </table>
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
