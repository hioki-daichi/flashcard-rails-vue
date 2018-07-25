<template>
  <v-container fluid>
    <v-layout>
      <v-flex offset-xs3 xs6>
        <v-form v-if="!this.$store.state.auth.jwt">
          <v-card flat>
            <v-card-text>
              <v-text-field type="text" placeholder="email" v-model="email" />
              <v-text-field type="password" placeholder="password" v-model="password" />
            </v-card-text>
            <v-card-actions>
              <v-btn large block color="primary" @click="submit">Login</v-btn>
            </v-card-actions>
          </v-card>
        </v-form>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script lang="ts">
import Vue from "vue";
import router from "../routes";

export default Vue.extend({
  computed: {
    email: {
      get() {
        return this.$store.state.auth.loginForm.email;
      },
      set(value) {
        this.$store.commit("auth/updateLoginForm", { email: value });
      }
    },
    password: {
      get() {
        return this.$store.state.auth.loginForm.password;
      },
      set(value) {
        this.$store.commit("auth/updateLoginForm", { password: value });
      }
    },
    previousUrl: {
      get() {
        return this.$store.state.global.previousUrl;
      },
      set(value) {
        this.$store.commit("global/setPreviousUrl", value);
      }
    }
  },
  methods: {
    submit() {
      this.$store.dispatch("auth/authenticate").then(_ => {
        this.email = "";
        this.password = "";
        if (this.previousUrl) {
          router.push(this.previousUrl, () => {
            this.previousUrl = null;
          });
        } else {
          router.push("/books");
        }
      });
    }
  }
});
</script>
