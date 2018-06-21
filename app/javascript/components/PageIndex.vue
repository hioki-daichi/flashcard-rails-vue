<template>
  <div>
    <h2>Pages</h2>
    <div class="flex-grid" v-for="page in this.$store.state.pages">
      <div class="col">{{ page.question }}</div>
      <div class="col">{{ page.answer }}</div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";

export default Vue.extend({
  props: ["bookId"],
  created() {
    this.$store.commit("setBookId", this.bookId);
    this.$store.dispatch("fetchPages");
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
