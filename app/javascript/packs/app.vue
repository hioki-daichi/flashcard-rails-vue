<template>
  <v-app :class="{ loading: this.$store.state.global.loading }">
    <Header />
    <v-content>
      <v-alert :value="!!alertMessage" type="error">{{alertMessage}}</v-alert>
      <router-view />
    </v-content>
  </v-app>
</template>

<script lang="ts">
import Header from "./components/shared/Header.vue";

export default {
  components: {
    Header
  },
  computed: {
    alertMessage() {
      return this.$store.state.global.alertMessage;
    }
  }
};
</script>

<style>
.loading {
  cursor: wait;
}
</style>
