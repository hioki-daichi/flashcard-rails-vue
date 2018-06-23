<template>
  <div>
    <h2>Pages</h2>
    <div class="flex-grid">
      <div class="col">
        <textarea placeholder="Question" v-model="question" />
        <textarea placeholder="Answer" v-model="answer" />
        <button @click="submit">Submit</button>
      </div>
    </div>
    <div class="flex-grid" v-for="page in this.$store.state.pages">
      <div class="col">{{ page.question }}</div>
      <div class="col">{{ page.answer }}</div>
      <button @click="destroy(page)">Delete</button>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";

export default Vue.extend({
  props: ["bookId"],
  created() {
    this.$store.commit("setBookId", this.bookId);
    this.$store.dispatch("fetchPages");
  },
  computed: {
    question: {
      get() {
        return this.$store.state.newPage.question;
      },
      set(value) {
        this.$store.commit("updateNewPageQuestion", value);
      }
    },
    answer: {
      get() {
        return this.$store.state.newPage.answer;
      },
      set(value) {
        this.$store.commit("updateNewPageAnswer", value);
      }
    }
  },
  methods: {
    submit() {
      this.$store.dispatch("createPage");
    },
    destroy(page) {
      this.$store.commit("setPageId", page.id);
      this.$store.dispatch("destroyPage");
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
