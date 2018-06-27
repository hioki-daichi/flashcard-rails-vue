<template>
  <div class="flex-grid">
    <template v-if="editing && this.page.id == editing.id">
      <textarea placeholder="Question" v-model="page.question" />
      <textarea placeholder="Answer" v-model="page.answer" />
      <button @click="update">Update</button>
    </template>
    <template v-else>
      <pre class="col">{{ page.question }}</pre>
      <pre class="col">{{ page.answer }}</pre>
      <button @click="edit">Edit</button>
      <button @click="destroy">Delete</button>
    </template>
  </div>
</template>

<script lang="ts">
import Vue from "vue";

export default Vue.extend({
  props: ["page"],
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
