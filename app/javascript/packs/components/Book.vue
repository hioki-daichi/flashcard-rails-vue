<template>
  <div>
    <span class="handle">=</span>
    <template v-if="editing && this.book.id == editing.id">
      <input type="text" v-model="book.title" />
      <button @click="update" :disabled="!changed">Update</button>
      <button @click="cancel">Cancel</button>
    </template>
    <template v-else>
      <router-link :to="{ name: 'bookDetail', params: { bookId: book.id } }">{{ book.title }}</router-link>
      <button @click="edit" :disabled="editing != null">Edit</button>
      <button @click="destroy" :disabled="editing != null">Delete</button>
    </template>
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
        return this.$store.state.book.editingBook;
      },
      set(value) {
        this.$store.commit("setEditingBook", value);
      }
    },
    changed: {
      get() {
        return Object.keys(this._beforeEditingCache).some(key => {
          return this._beforeEditingCache[key] != this.editing[key];
        });
      }
    }
  },
  methods: {
    edit() {
      this._beforeEditingCache = Object.assign({}, this.book);
      this.editing = this.book;
    },
    update() {
      this.$store.dispatch("updateBook");
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

<style scoped>
.handle {
  cursor: move;
}
</style>
