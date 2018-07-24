<template>
  <tr>
    <template v-if="editing && this.page.id == editing.id">
      <td class="icon"><v-icon disabled>drag_handle</v-icon></td>
      <td class="path"><v-text-field type="text" placeholder="Path" v-model="page.path" /></td>
      <td class="question"><v-textarea placeholder="Question" v-model="page.question" /></td>
      <td class="answer"><v-textarea placeholder="Answer" v-model="page.answer" /></td>
      <td class="icon"><v-icon @click="update" :disabled="!changed">check</v-icon></td>
      <td class="icon"><v-icon @click="cancel">close</v-icon></td>
    </template>
    <template v-else>
      <td class="icon"><v-icon class="handle">drag_handle</v-icon></td>
      <td class="path">{{ page.path }}</td>
      <td class="question">{{ page.question }}</td>
      <td class="answer">{{ page.answer }}</td>
      <td class="icon"><v-icon @click="edit" :disabled="editing != null">edit</v-icon></td>
      <td class="icon"><v-icon @click="destroy" :disabled="editing != null">remove_circle</v-icon></td>
    </template>
  </tr>
</template>

<script lang="ts">
import Vue from "vue";

export default Vue.extend({
  props: ["page"],
  data() {
    return {
      _beforeEditingCache: null
    };
  },
  computed: {
    editing: {
      get() {
        return this.$store.state.page.editing;
      },
      set(value) {
        this.$store.commit("page/setEditing", value);
      }
    },
    changed: {
      get() {
        return Object.keys(this._beforeEditingCache).some(key => {
          return this._beforeEditingCache[key] != this.editing[key];
        });
      }
    }
  },
  methods: {
    edit() {
      this._beforeEditingCache = Object.assign({}, this.page);
      this.editing = this.page;
    },
    update() {
      this.$store.dispatch("page/update");
    },
    cancel() {
      Object.assign(this.page, this._beforeEditingCache);
      this.editing = this._beforeEditingCache = null;
    },
    destroy() {
      const confirmed = window.confirm("Are you sure ?");
      if (confirmed) {
        this.$store.commit("page/setId", this.page.id);
        this.$store.dispatch("page/destroy");
      }
    }
  }
});
</script>

<style scoped>
li {
  display: inline-block;
  vertical-align: middle;
}
textarea {
  resize: auto;
  min-width: 200px;
  min-height: 100px;
}
pre {
  width: 200px;
}
.handle {
  cursor: move;
}
td {
  white-space: pre-line;
}
td.icon {
  width: 20px;
}
td.path {
  width: 20%;
}
td.question {
  width: 40%;
}
td.answer {
  width: 40%;
}
</style>
