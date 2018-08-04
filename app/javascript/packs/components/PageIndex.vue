<template>
  <v-container fluid>
    <v-layout>
      <v-dialog v-model="dialog">
        <v-btn slot="activator" small>New</v-btn>
        <v-card>
          <v-card-text>
            <v-container>
              <v-layout wrap>
                <v-flex xs12>
                  <v-text-field type="text" placeholder="Path" v-model="path" />
                </v-flex>
                <v-flex xs12>
                  <v-textarea placeholder="Question" v-model="question" />
                </v-flex>
                <v-flex xs12>
                  <v-textarea placeholder="Answer" v-model="answer" />
                </v-flex>
              </v-layout>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn @click.native="dialog = false">Cancel</v-btn>
            <v-btn color="primary" @click.native="submit">Submit</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
      <v-btn @click="exportBook" small>Export</v-btn>
    </v-layout>
    <v-layout style="margin-top: 24px;">
      <v-flex>
        <draggable element="table" :options="{ handle: '.handle' }" @end="onEnd">
          <Page v-for="page in pages" :page="page" :key="page.sub"></Page>
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
  props: ["bookSub"],
  created() {
    this.$store.commit("book/setSub", this.bookSub);
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
  data() {
    return {
      dialog: false
    };
  },
  methods: {
    onEnd(e) {
      this.$store.commit("page/setSub", this.pages[e.oldIndex].sub);
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
