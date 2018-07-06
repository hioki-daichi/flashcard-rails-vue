import axios from "axios";
import store from "./index";
import router from "../routes";

axios.interceptors.request.use(config => {
  const token = store.state.jwt;
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }

  store.commit("setLoading", true);

  return config;
});

axios.interceptors.response.use(
  response => {
    store.commit("setLoading", false);

    return response;
  },
  error => {
    store.commit("setLoading", false);

    switch (error.response.status) {
      case 400: {
        alert(error.response.data.errors.join("\n"));
        break;
      }
      case 401: {
        alert("Authentication failed.");
        break;
      }
      case 404: {
        alert("Resource was not found.");
        break;
      }
      // token expired
      case 419: {
        alert(error.response.data.errors.join("\n"));
        store.commit("setPreviousUrl", router.currentRoute.path);
        store.commit("setJWT", null);
        router.push("/login");
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
