<template>
  <v-container>
    <v-layout>
      <v-flex>
        <v-btn @click="exportBook">Export</v-btn>
        <div>
          <v-text-field type="text" placeholder="Path" v-model="path" />
          <v-textarea placeholder="Question" v-model="question" />
          <v-textarea placeholder="Answer" v-model="answer" />
          <v-btn @click="submit">Submit</v-btn>
        </div>
        <draggable element="table" :options="{ handle: '.handle' }" @end="onEnd">
          <Page v-for="page in pages" :page="page" :key="page.id"></Page>
        </draggable>
      </v-flex>
    </v-layout>
  </v-container>
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
    this.$store.commit("book/setId", this.bookId);
    this.$store.dispatch("page/fetch");
  },
  destroyed() {
    this.$store.commit("page/setList", []);
  },
  computed: {
    pages() {
      return this.$store.state.page.list;
    },
    path: {
      get() {
        return this.$store.state.page.newObject.path;
      },
      set(value) {
        this.$store.commit("page/updateNewObject", { path: value });
      }
    },
    question: {
      get() {
        return this.$store.state.page.newObject.question;
      },
      set(value) {
        this.$store.commit("page/updateNewObject", { question: value });
      }
    },
    answer: {
      get() {
        return this.$store.state.page.newObject.answer;
      },
      set(value) {
        this.$store.commit("page/updateNewObject", { answer: value });
      }
    }
  },
  methods: {
    onEnd(e) {
      this.$store.commit("page/setId", this.pages[e.oldIndex].id);
      this.$store.commit("page/setNewIndex", e.newIndex);
      this.$store.dispatch("page/sort");
    },
    submit() {
      this.$store.dispatch("page/create");
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
