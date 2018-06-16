<template>
  <div>
    <h2>Pages</h2>
    <table>
      <tbody>
        <tr v-for="page in pages">
          <td>{{ page.question }}</td>
          <td>{{ page.answer }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import axios from "axios";

interface Page {
  id: number;
  question: string;
  answer: string;
}

export default Vue.extend({
  data: function() {
    return {
      pages: [] as Page[]
    };
  },
  async created() {
    try {
      const res = await axios.get("/ajax/books/1/pages"); // XXX Specify proper :book_id
      this.pages = res.data;
    } catch (e) {
      alert(e);
    }
  }
});
</script>
