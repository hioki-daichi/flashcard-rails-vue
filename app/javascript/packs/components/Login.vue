<template>
  <form v-if="!this.$store.state.jwt">
    <input type="text" placeholder="email" v-model="email" />
    <input type="password" placeholder="password" v-model="password" />
    <button @click="submit">Submit</button>
  </form>
</template>

<script lang="ts">
import Vue from "vue";
import router from "../routes";

export default Vue.extend({
  computed: {
    email: {
      get() {
        return this.$store.state.loginForm.email;
      },
      set(value) {
        this.$store.commit("updateLoginForm", { email: value });
      }
    },
    password: {
      get() {
        return this.$store.state.loginForm.password;
      },
      set(value) {
        this.$store.commit("updateLoginForm", { password: value });
      }
    },
    previousUrl: {
      get() {
        return this.$store.state.global.previousUrl;
      },
      set(value) {
        this.$store.commit("setPreviousUrl", value);
      }
    }
  },
  methods: {
    submit() {
      this.$store.dispatch("authenticate").then(_ => {
        this.email = "";
        this.password = "";
        if (this.previousUrl) {
          router.push(this.previousUrl);
          this.previousUrl = null;
        } else {
          router.push("/books");
        }
      });
    }
  }
});
</script>
