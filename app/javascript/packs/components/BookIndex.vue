<template>
  <v-container>
    <v-layout>
      <v-flex>
        <h2>Books</h2>
        <v-form>
          <v-text-field type="text" placeholder="Title" v-model="newBookTitle" />
          <v-btn @click="submit">Submit</v-btn>
          <draggable element="table" :options="{ handle: '.handle' }" @end="onEnd">
            <Book v-for="book in books" :book="book" :key="book.id"></Book>
          </draggable>
        </v-form>
      </v-flex>
    </v-layout>
    <v-layout>
      <v-flex>
        <h2>Import</h2>
        <v-form>
          <input type="file" @change="fileSelected" ref="fileInput" />
          <v-select :items="colSepOptions" v-model="colSep"></v-select>
          <v-btn @click="importBook">Upload</v-btn>
        </v-form>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script lang="ts">
import Vue from "vue";
import Book from "./Book.vue";
import draggable from "vuedraggable";

export default Vue.extend({
  components: {
    Book,
    draggable
  },
  created() {
    this.$store.dispatch("book/fetch");
  },
  destroyed() {
    this.$store.commit("book/setList", []);
  },
  computed: {
    books() {
      return this.$store.state.book.list;
    },
    newBookTitle: {
      get() {
        return this.$store.state.book.newObject.title;
      },
      set(value) {
        this.$store.commit("book/updateNewObject", { title: value });
      }
    },
    colSep: {
      get() {
        return this.$store.state.book.colSep;
      },
      set(value) {
        this.$store.commit("book/setColSep", value);
      }
    }
  },
  data() {
    return {
      colSepOptions: [
        { text: ",", value: "comma" },
        { text: "\\t", value: "tab" }
      ]
    };
  },
  methods: {
    onEnd(e) {
      this.$store.commit("book/setId", this.books[e.oldIndex].id);
      this.$store.commit("book/setNewIndex", e.newIndex);
      this.$store.dispatch("book/sort");
    },
    submit() {
      this.$store.dispatch("book/create");
    },
    fileSelected(e) {
      this.$store.commit("book/setSelectedFile", e.target.files[0]);
    },
    importBook() {
      this.$store.dispatch("book/importBook").then(_ => {
        this.$refs.fileInput.value = "";
      });
    }
  }
});
</script>
