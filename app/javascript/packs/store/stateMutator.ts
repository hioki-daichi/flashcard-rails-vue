export const set = propName => (state, value) => {
  state[propName] = value;
};

export const assign = propName => (state, value) => {
  state[propName] = Object.assign(state[propName], value);
};

export const replaceById = propName => (state, value) => {
  state[propName] = state[propName].map(obj => {
    if (obj.id == value.id) {
      return value;
    } else {
      return obj;
    }
  });
};

export const omitById = propName => (state, value) => {
  state[propName] = state[propName].filter(obj => {
    return obj.id != value;
  });
};

export const unshiftTo = propName => (state, value) => {
  state[propName].unshift(value);
};

export const pushTo = propName => (state, value) => {
  state[propName].push(value);
};
