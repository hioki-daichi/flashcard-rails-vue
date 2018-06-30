<template>
  <div>
    <div v-if="editing && this.book.id == editing.id">
      <input type="text" v-model="book.title" />
      <button @click="update">Update</button>
      <button @click="cancel">Cancel</button>
    </div>
    <div v-else>
      <router-link :to="{ name: 'bookPages', params: { bookId: book.id } }">{{ book.title }}</router-link>
      <button @click="edit" :disabled="editing != null">Edit</button>
      <button @click="destroy" :disabled="editing != null">Delete</button>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";

export default Vue.extend({
  props: ["book"],
  data() {
    return {
      _beforeEditingCache: null
    };
  },
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
      this._beforeEditingCache = Object.assign({}, this.book);
      this.editing = this.book;
    },
    update() {
      this.$store.dispatch("updateBook").then(_ => {
        this.editing = null;
      });
    },
    cancel() {
      Object.assign(this.book, this._beforeEditingCache);
      this.editing = this._beforeEditingCache = null;
    },
    destroy() {
      const confirmed = window.confirm("Are you sure ?");
      if (confirmed) {
        this.$store.commit("setBookId", this.book.id);
        this.$store.dispatch("destroyBook");
      }
    }
  }
});
</script>
