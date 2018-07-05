<template>
  <tr>
    <template v-if="editing && this.page.id == editing.id">
      <td><input type="text" placeholder="Path" v-model="page.path" /></td>
      <td><textarea placeholder="Question" v-model="page.question" /></td>
      <td><textarea placeholder="Answer" v-model="page.answer" /></td>
      <td><button @click="update" :disabled="!changed">Update</button></td>
      <td><button @click="cancel">Cancel</button></td>
    </template>
    <template v-else>
      <td class="handle">=</td>
      <td>{{ page.path }}</td>
      <td>{{ page.question }}</td>
      <td>{{ page.answer }}</td>
      <td><button @click="edit" :disabled="editing != null">Edit</button></td>
      <td><button @click="destroy" :disabled="editing != null">Delete</button></td>
    </template>
  </tr>
</template>

<script lang="ts">
import Vue from "vue";

export default Vue.extend({
  props: ["page"],
  data() {
    return {
      _beforeEditingCache: null
    };
  },
  computed: {
    editing: {
      get() {
        return this.$store.state.editingPage;
      },
      set(value) {
        this.$store.commit("setEditingPage", value);
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
      this._beforeEditingCache = Object.assign({}, this.page);
      this.editing = this.page;
    },
    update() {
      this.$store.dispatch("updatePage");
    },
    cancel() {
      Object.assign(this.page, this._beforeEditingCache);
      this.editing = this._beforeEditingCache = null;
    },
    destroy() {
      const confirmed = window.confirm("Are you sure ?");
      if (confirmed) {
        this.$store.commit("setPageId", this.page.id);
        this.$store.dispatch("destroyPage");
      }
    }
  }
});
</script>

<style scoped>
li {
  display: inline-block;
  vertical-align: middle;
}
textarea {
  resize: auto;
  min-width: 200px;
  min-height: 100px;
}
pre {
  width: 200px;
}
.handle {
  cursor: move;
}
td {
  white-space: pre-line;
}
</style>
