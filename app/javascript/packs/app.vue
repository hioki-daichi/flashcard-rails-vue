<template>
  <v-app :class="{ loading: this.$store.state.global.loading }">
    <Header />
    <v-content fluid style="margin-top: 48px">
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
table {
  border-collapse: collapse;
}
.align-top {
  vertical-align: top;
}
* {
  font-size: 12px;
}
</style>
