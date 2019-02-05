const { get } = require('../utils');

const CURRENT_WEATHER_URL = 'https://api.openweathermap.org/data/2.5/weather';

module.exports = {
  byCityName: ({}, { name, countryCode }) => {
    const location = [name];
    if (countryCode && countryCode.trim()) {
      location.push(countryCode.trim());
    }
    return get(CURRENT_WEATHER_URL, {
      q: location.join()
    });
  },
  byCityID: ({ lang }, { id }) =>
    get(CURRENT_WEATHER_URL, {
      lang,
      id
    }),
  byLatLon: ({ lang }, { lat, lon }) =>
    get(CURRENT_WEATHER_URL, {
      lat,
      lon,
      lang
    }),
  byZIP: ({ lang }, { zip, countryCode }) => {
    const location = [zip];
    if (countryCode && countryCode.trim()) {
      location.push(countryCode.trim());
    }
    return get(CURRENT_WEATHER_URL, {
      zip: location.join(),
      lang
    });
  }
};
