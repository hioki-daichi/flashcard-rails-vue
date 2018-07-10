import mutator from "../mutator";

export default {
  namespaced: true,
  state: {
    previousUrl: null,
    loading: false
  },
  mutations: {
    setPreviousUrl: mutator.set("previousUrl"),
    setLoading: mutator.set("loading")
  }
};
