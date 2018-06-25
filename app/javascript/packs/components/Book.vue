<template>
  <div>
    <router-link :to="{ name: 'bookPages', params: { bookId: book.id } }">{{ book.title }}</router-link>
    <button @click="destroy">Delete</button>
  </div>
</template>

<script lang="ts">
import Vue from "vue";

export default Vue.extend({
  props: ["book"],
  methods: {
    destroy() {
      this.$store.commit("setBookId", this.book.id);
      this.$store.dispatch("destroyBook");
    }
  }
})
</script>
