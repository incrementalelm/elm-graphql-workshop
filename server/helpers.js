const _ = require("lodash");
const axios = require("axios");

function get(url, queries = {}) {
  const queryString = _.chain({ ...queries })
    .toPairs()
    .map(p => p.join("="))
    .join("&")
    .value();
  const getUrl = `${url}?${queryString}`;
  return axios.get(getUrl).then(({ data }) => data);
}

const CURRENT_WEATHER_URL = "http://api.apixu.com/v1/current.json";

module.exports = {
  get,
  CURRENT_WEATHER_URL
};
