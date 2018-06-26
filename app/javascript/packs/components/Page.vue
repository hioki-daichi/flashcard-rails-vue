<template>
  <div class="flex-grid">
    <template v-if="this.editing">
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
      this.$store.commit("setUpdatingPage", this.page);
      this.$store.dispatch("updatePage");
      this.editing = false;
    },
    destroy() {
      const confirmed = window.confirm("Are you sure ?")
      if (confirmed) {
        this.$store.commit("setPageId", this.page.id);
        this.$store.dispatch("destroyPage");
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
