<template>
  <div>
    <button @click="exportBook">Export</button>
    <div>
      <input type="text" placeholder="Path" v-model="path" />
      <textarea placeholder="Question" v-model="question" />
      <textarea placeholder="Answer" v-model="answer" />
      <button @click="submit">Submit</button>
    </div>
    <draggable element="table" :options="{ handle: '.handle' }" @end="onEnd">
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
    this.$store.commit("book/setBookId", this.bookId);
    this.$store.dispatch("page/fetchPages");
  },
  destroyed() {
    this.$store.commit("page/setPages", []);
  },
  computed: {
    pages() {
      return this.$store.state.page.pages;
    },
    path: {
      get() {
        return this.$store.state.page.newPage.path;
      },
      set(value) {
        this.$store.commit("page/updateNewPage", { path: value });
      }
    },
    question: {
      get() {
        return this.$store.state.page.newPage.question;
      },
      set(value) {
        this.$store.commit("page/updateNewPage", { question: value });
      }
    },
    answer: {
      get() {
        return this.$store.state.page.newPage.answer;
      },
      set(value) {
        this.$store.commit("page/updateNewPage", { answer: value });
      }
    }
  },
  methods: {
    onEnd(e) {
      this.$store.commit("page/setPageId", this.pages[e.oldIndex].id);
      this.$store.commit("page/setNewIndex", e.newIndex);
      this.$store.dispatch("page/sort");
    },
    submit() {
      this.$store.dispatch("page/createPage");
    },
    exportBook() {
      this.$store.dispatch("book/exportBook");
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
