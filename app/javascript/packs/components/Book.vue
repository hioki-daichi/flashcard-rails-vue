<template>
  <tr>
    <td><v-icon class="handle" :disabled="!!editing">drag_handle</v-icon></td>
    <template v-if="editing && this.book.id == editing.id">
      <td class="title"><v-text-field type="text" v-model="book.title" /></td>
      <td><v-icon @click="update" :disabled="!changed">check</v-icon></td>
      <td><v-icon @click="cancel">close</v-icon></td>
    </template>
    <template v-else>
      <td class="title"><router-link :to="{ name: 'bookDetail', params: { bookId: book.id } }">{{ book.title }}</router-link></td>
      <td><v-icon @click="edit" :disabled="editing != null">edit</v-icon></td>
      <td><v-icon @click="destroy" :disabled="editing != null">delete</v-icon></td>
    </template>
  </tr>
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
        return this.$store.state.book.editing;
      },
      set(value) {
        this.$store.commit("book/setEditing", value);
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
      this.$store.dispatch("book/update");
    },
    cancel() {
      Object.assign(this.book, this._beforeEditingCache);
      this.editing = this._beforeEditingCache = null;
    },
    destroy() {
      const confirmed = window.confirm("Are you sure ?");
      if (confirmed) {
        this.$store.commit("book/setId", this.book.id);
        this.$store.dispatch("book/destroy");
      }
    }
  }
});
</script>

<style scoped>
.handle {
  cursor: move;
}
tr {
  border-top: 1px solid #eee;
}
tr:last-child {
  border-bottom: 1px solid #eee;
}
td {
  white-space: pre-line;
  padding: 1px 8px 0;
}
td i {
  vertical-align: middle;
}
td a {
  vertical-align: 4px;
}
td.title {
  width: 100%;
}
</style>
