<template>
  <div>
    <h2>Pages</h2>
    <table>
      <tbody>
        <tr v-for="page in this.$store.state.pages">
          <td>{{ page.question }}</td>
          <td>{{ page.answer }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script lang="ts">
import Vue from "vue";

export default Vue.extend({
  props: ["bookId"],
  created() {
    this.$store.commit("setCurrentBookId", this.bookId);
    this.$store.dispatch("fetchPages");
  }
});
</script>
