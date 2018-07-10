<template>
  <header>
    <router-link to="/" tabindex=-1>Flashcard</router-link>
    <template v-if="this.$store.state.auth.jwt">
      <a @click.prevent="logout" href>logout</a>
    </template>
  </header>
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
