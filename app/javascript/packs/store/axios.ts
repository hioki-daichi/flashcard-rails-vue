import axios from "axios";

axios.interceptors.request.use(config => {
  console.log(config);

  axios.defaults.headers.common["X-CSRF-Token"] = document
    .querySelector('meta[name="csrf-token"]')
    .getAttribute("content");

  return config;
});

axios.interceptors.response.use(response => {
  console.log(response);
  return response;
});

export default axios;
