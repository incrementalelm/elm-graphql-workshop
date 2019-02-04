const { get } = require('../utils');

const CURRENT_WEATHER_URL = 'https://api.openweathermap.org/data/2.5/weather';

module.exports = {
  byCityName: ({ units }, { name, countryCode }) => {
    const location = [name];
    if (countryCode && countryCode.trim()) {
      location.push(countryCode.trim());
    }
    return get(CURRENT_WEATHER_URL, {
      q: location.join()
    });
  },
  byCityID: ({ lang, units }, { id }) =>
    get(CURRENT_WEATHER_URL, {
      units,
      lang,
      id
    }),
  byLatLon: ({ lang, units }, { lat, lon }) =>
    get(CURRENT_WEATHER_URL, {
      lat,
      lon,
      units,
      lang
    }),
  byZIP: ({ lang, units }, { zip, countryCode }) => {
    const location = [zip];
    if (countryCode && countryCode.trim()) {
      location.push(countryCode.trim());
    }
    return get(CURRENT_WEATHER_URL, {
      zip: location.join(),
      units,
      lang
    });
  }
};
