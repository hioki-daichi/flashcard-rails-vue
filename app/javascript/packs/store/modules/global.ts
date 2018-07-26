import mutator from "../mutator";

export default {
  namespaced: true,
  state: {
    previousUrl: null,
    loading: false,
    alertMessage: null
  },
  mutations: {
    setPreviousUrl: mutator.set("previousUrl"),
    setLoading: mutator.set("loading"),
    setAlertMessage: mutator.set("alertMessage")
  }
};
