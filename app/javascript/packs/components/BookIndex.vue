<template>
  <v-container fluid>
    <v-layout>
      <v-dialog v-model="newDialog">
        <v-btn slot="activator" small>New</v-btn>
        <v-card>
          <v-card-text>
            <v-container>
              <v-layout>
                <v-flex xs8 offset-xs2>
                  <v-text-field type="text" placeholder="Title" v-model="newBookTitle" />
                </v-flex>
              </v-layout>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn @click.native="newDialog = false">Cancel</v-btn>
            <v-btn color="primary" @click.native="submit">Create</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
      <v-dialog v-model="importDialog">
        <v-btn slot="activator" small>Import</v-btn>
        <v-card>
          <v-card-text>
            <v-container>
              <v-layout wrap>
                <v-flex xs12>
                  <input type="file" @change="fileSelected" ref="fileInput" />
                </v-flex>
                <v-flex xs1>
                  <v-select :items="colSepOptions" v-model="colSep"></v-select>
                </v-flex>
              </v-layout>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn @click.native="importDialog = false">Cancel</v-btn>
            <v-btn color="primary" @click.native="importBook">Upload</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-layout>
    <v-layout style="margin-top: 24px;">
      <v-flex>
        <v-form>
          <draggable element="table" :options="{ handle: '.handle' }" @end="onEnd">
            <Book v-for="book in books" :book="book" :key="book.id"></Book>
          </draggable>
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
      newDialog: false,
      importDialog: false,
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
      this.newDialog = false;
    },
    fileSelected(e) {
      this.$store.commit("book/setSelectedFile", e.target.files[0]);
    },
    importBook() {
      this.$store.dispatch("book/importBook").then(_ => {
        this.$refs.fileInput.value = "";
        this.importDialog = false;
      });
    }
  }
});
</script>
