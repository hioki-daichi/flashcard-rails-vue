<template>
  <div>
    <button @click="exportBook">Export</button>
    <div>
      <input type="text" placeholder="Path" v-model="path" />
      <textarea placeholder="Question" v-model="question" />
      <textarea placeholder="Answer" v-model="answer" />
      <button @click="submit">Submit</button>
    </div>
    <draggable v-model="pages" :options="{ handle: '.handle' }">
      <Page v-for="page in pages" :page="page" :key="page.id"></Page>
    </draggable>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import Page from "./Page.vue";
import draggable from "vuedraggable";

export default Vue.extend({
  components: {
    Page,
    draggable
  },
  props: ["bookId"],
  created() {
    this.$store.commit("setBookId", this.bookId);
    this.$store.dispatch("fetchPages");
  },
  computed: {
    pages: {
      get() {
        return this.$store.state.pages;
      },
      set(value) {
        this.$store.commit("setPages", value);
        this.$store.dispatch("updatePagePositions");
      }
    },
    path: {
      get() {
        return this.$store.state.newPage.path;
      },
      set(value) {
        this.$store.commit("updateNewPage", { path: value });
      }
    },
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
