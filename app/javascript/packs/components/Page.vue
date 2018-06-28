<template>
  <div>
    <ul v-if="editing && this.page.id == editing.id">
      <li><textarea placeholder="Question" v-model="page.question" /></li>
      <li><textarea placeholder="Answer" v-model="page.answer" /></li>
      <li><button @click="update">Update</button></li>
      <li><button @click="cancel">Cancel</button></li>
    </ul>
    <ul v-else>
      <li><pre>{{ page.question }}</pre></li>
      <li><pre>{{ page.answer }}</pre></li>
      <li><button @click="edit">Edit</button></li>
      <li><button @click="destroy">Delete</button></li>
    </ul>
  </div>
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
    }
  },
  methods: {
    edit() {
      this._beforeEditingCache = Object.assign({}, this.page);
      this.editing = this.page;
    },
    update() {
      this.$store
        .dispatch("updatePage")
        .then(res => {
          this.editing = null;
        })
        .catch(error => {
          console.warn(error);
        });
    },
    cancel() {
      Object.assign(this.page, this._beforeEditingCache);
      this.editing = this._beforeEditingCache = null;
    },
    destroy() {
      const confirmed = window.confirm("Are you sure ?");
      if (confirmed) {
        this.$store.commit("setPageId", this.page.id);
        this.$store
          .dispatch("destroyPage")
          .then(res => {})
          .catch(error => {
            console.warn(error);
          });
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
</style>
