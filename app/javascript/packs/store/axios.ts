import axios from "axios";
import store from "./index";
import router from "../routes";

axios.interceptors.request.use(config => {
  const token = store.state.auth.jwt;
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }

  store.commit("global/setLoading", true);

  return config;
});

const showAlert = (message, commit) => {
  const key = "global/setAlertMessage";
  commit(key, message, { root: true });
  setTimeout(() => {
    commit(key, null, { root: true });
  }, 2000);
};

axios.interceptors.response.use(
  response => {
    store.commit("global/setLoading", false);

    return response;
  },
  error => {
    store.commit("global/setLoading", false);

    switch (error.response.status) {
      case 400: {
        alert(error.response.data.errors.join("\n"));
        break;
      }
      case 401: {
        store.commit("global/setAlertMessage", "Authentication failed.", {
          root: true
        });
        break;
      }
      case 404: {
        router.push("/", () => {
          showAlert(error.response.data.errors.join(", "), store.commit);
        });
        break;
      }
      // token expired
      case 419: {
        alert(error.response.data.errors.join("\n"));
        store.commit("global/setPreviousUrl", router.currentRoute.path);
        store.commit("auth/setJWT", null);
        router.push("/login");
        break;
      }
      // Too Many Requests
      case 429: {
        break;
      }
      default: {
        alert("Unexpected errors occurred.");
      }
    }
    return Promise.reject(error);
  }
);

export default axios;
