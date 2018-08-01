const set = propName => (state, value) => {
  state[propName] = value;
};

const assign = propName => (state, value) => {
  state[propName] = Object.assign(state[propName], value);
};

const replaceById = propName => (state, value) => {
  state[propName] = state[propName].map(obj => {
    if (obj.id == value.id) {
      return value;
    } else {
      return obj;
    }
  });
};

const replaceBySub = propName => (state, value) => {
  state[propName] = state[propName].map(obj => {
    if (obj.sub == value.sub) {
      return value;
    } else {
      return obj;
    }
  });
};

const omitById = propName => (state, value) => {
  state[propName] = state[propName].filter(obj => {
    return obj.id != value;
  });
};

const omitBySub = propName => (state, value) => {
  state[propName] = state[propName].filter(obj => {
    return obj.sub != value;
  });
};

const pushTo = propName => (state, value) => {
  state[propName].push(value);
};

export default {
  set,
  assign,
  replaceById,
  replaceBySub,
  omitById,
  omitBySub,
  pushTo
};
