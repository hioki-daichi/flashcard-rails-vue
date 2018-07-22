<template>
  <v-toolbar>
    <v-toolbar-title>
      <router-link to="/" tabindex=-1>Flashcard</router-link>
    </v-toolbar-title>
    <v-spacer />
    <v-toolbar-items>
      <template v-if="this.$store.state.auth.jwt">
        <v-btn flat @click.prevent="logout">logout</v-btn>
      </template>
    </v-toolbar-items>
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
