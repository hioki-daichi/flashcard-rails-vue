import axios from "axios";

axios.interceptors.request.use(config => {
  console.log(config);
  return config;
});

axios.interceptors.response.use(response => {
  console.log(response);
  return response;
});

export default axios;
