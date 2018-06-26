<template>
  <div>
    <div v-if="this.editing">
      <input type="text" v-model="book.title" />
      <button @click="update">Update</button>
    </div>
    <div v-else>
      <router-link :to="{ name: 'bookPages', params: { bookId: book.id } }">{{ book.title }}</router-link>
      <button @click="edit">Edit</button>
      <button @click="destroy">Delete</button>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";

export default Vue.extend({
  props: ["book"],
  data() {
    return {
      editing: false
    };
  },
  methods: {
    edit() {
      this.editing = true;
    },
    update() {
      this.$store.commit("setUpdatingBook", this.book);
      this.$store.dispatch("updateBook");
      this.editing = false;
    },
    destroy() {
      this.$store.commit("setBookId", this.book.id);
      this.$store.dispatch("destroyBook");
    }
  }
});
</script>
