<template>
  <v-app :class="{ loading: this.$store.state.global.loading }">
    <Header />
    <v-content>
      <router-view />
    </v-content>
  </v-app>
</template>

<script lang="ts">
import Header from "./components/shared/Header.vue";

export default {
  components: {
    Header
  }
};
</script>

<style>
.loading {
  cursor: wait;
}
</style>
