<template>
  <div>
    <h2>Books</h2>
    <table>
      <tbody>
        <tr v-for="book in books">
          <td>{{ book.title }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import axios from 'axios'

interface Book {
  id: number
  title: string
}

export default Vue.extend({
  data: function() {
    return {
      books: [] as Book[]
    };
  },
  async created() {
    try {
      const res = await axios.get("/ajax/books")
      this.books = res.data
    } catch (e) {
      alert(e)
    }
  }
});
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
