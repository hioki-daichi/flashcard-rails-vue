import axios from "axios";
import store from "./index";

axios.interceptors.request.use(config => {
  axios.defaults.headers.common["X-CSRF-Token"] = document
    .querySelector('meta[name="csrf-token"]')
    .getAttribute("content");

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
      default: {
        alert("Unexpected errors occurred.");
      }
    }
    return Promise.reject(error);
  }
);

export default axios;
