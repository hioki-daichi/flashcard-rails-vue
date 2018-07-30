<template>
  <v-toolbar dense fixed flat>
    <v-toolbar-title>
      <v-btn flat to="/">flashcard</v-btn>
    </v-toolbar-title>
    <v-spacer />
    <template v-if="this.$store.state.auth.jwt">
      <v-btn flat @click="logout">Logout</v-btn>
    </template>
  </v-toolbar>
</template>

<script lang="ts">
import Vue from "vue";
import router from "../../routes";

export default Vue.extend({
  methods: {
    logout() {
      this.$store.commit("auth/setJWT", null);
      router.push("/login");
    }
  }
});
</script>
