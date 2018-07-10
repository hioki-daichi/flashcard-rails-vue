import axios from "../axios";
import mutator from "../mutator";

export default {
  namespaced: true,
  state: {
    jwt: localStorage.getItem("flashcard:user-token"),
    loginForm: {
      email: null,
      password: null
    }
  },
  mutations: {
    setJWT(state, value) {
      state.jwt = value;
      if (value) {
        localStorage.setItem("flashcard:user-token", value);
      } else {
        localStorage.removeItem("flashcard:user-token");
      }
    },
    updateLoginForm: mutator.assign("loginForm")
  },
  actions: {
    authenticate({ state, commit }) {
      const data = new FormData();
      data.append("email", state.loginForm.email);
      data.append("password", state.loginForm.password);
      return axios.post("/api/auth", data).then(res => {
        commit("setJWT", res.data.token);
      });
    }
  }
};
