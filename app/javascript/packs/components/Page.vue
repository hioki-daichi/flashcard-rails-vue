<template>
  <div class="flex-grid">
    <div class="col">{{ page.question }}</div>
    <div class="col">{{ page.answer }}</div>
    <button @click="destroy">Delete</button>
  </div>
</template>

<script lang="ts">
import Vue from "vue";

export default Vue.extend({
  props: ["page"],
  methods: {
    destroy() {
      this.$store.commit("setPageId", this.page.id);
      this.$store.dispatch("destroyPage");
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
textarea {
  min-width: 200px;
  min-height: 100px;
}
</style>
