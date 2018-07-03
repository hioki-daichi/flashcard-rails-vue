<template>
  <div id="app" :class="{ loading: this.$store.state.loading }">
    <Header />
    <router-view />
  </div>
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
