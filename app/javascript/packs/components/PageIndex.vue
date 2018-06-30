<template>
  <div>
    <button @click="exportBook">Export</button>
    <div>
      <textarea placeholder="Question" v-model="question" />
      <textarea placeholder="Answer" v-model="answer" />
      <button @click="submit">Submit</button>
    </div>
    <Page v-for="page in this.$store.state.pages" :page="page" :key="page.id"></Page>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import Page from "./Page.vue";

export default Vue.extend({
  components: {
    Page
  },
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
        this.$store.commit("updateNewPage", { question: value });
      }
    },
    answer: {
      get() {
        return this.$store.state.newPage.answer;
      },
      set(value) {
        this.$store.commit("updateNewPage", { answer: value });
      }
    }
  },
  methods: {
    submit() {
      this.$store.dispatch("createPage");
    },
    exportBook() {
      this.$store.dispatch("exportBook");
    }
  }
});
</script>

<style scoped>
textarea {
  min-width: 200px;
  min-height: 100px;
}
</style>
