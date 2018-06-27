import axios from "axios";

axios.interceptors.request.use(config => {
  console.log(config);

  axios.defaults.headers.common["X-CSRF-Token"] = document
    .querySelector('meta[name="csrf-token"]')
    .getAttribute("content");

  return config;
});

axios.interceptors.response.use(
  response => {
    console.log(response);
    return response;
  },
  error => {
    switch (error.response.status) {
      case 400: {
        alert(error.response.data.errors.join("\n"));
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
