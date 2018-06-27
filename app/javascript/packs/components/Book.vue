<template>
  <div>
    <div v-if="editing && this.book.id == editing.id">
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
  computed: {
    editing: {
      get() {
        return this.$store.state.editingBook;
      },
      set(value) {
        this.$store.commit("setEditingBook", value);
      }
    }
  },
  methods: {
    edit() {
      this.editing = this.book;
    },
    update() {
      this.$store
        .dispatch("updateBook")
        .then(res => {
          this.editing = null;
        })
        .catch(error => {
          console.warn(error);
        });
    },
    destroy() {
      const confirmed = window.confirm("Are you sure ?");
      if (confirmed) {
        this.$store.commit("setBookId", this.book.id);
        this.$store
          .dispatch("destroyBook")
          .then(res => {})
          .catch(error => {
            console.warn(error);
          });
      }
    }
  }
});
</script>
