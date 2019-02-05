const axios = require('axios');
const _ = require('lodash');
const APPID = require('../app-id');

module.exports = {
  get: (url, queries = {}) => {
    const queryString = _.chain({ ...queries, APPID })
      .toPairs()
      .map(p => p.join('='))
      .join('&')
      .value();
    const getUrl = `${url}?${queryString}`;
    console.log(getUrl);
    return axios.get(getUrl).then(({ data }) => data);
  }
};
