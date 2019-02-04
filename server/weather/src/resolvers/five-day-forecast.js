const { get } = require('../utils');
const CURRENT_FORECAST_URL = `https://api.openweathermap.org/data/2.5/forecast`;

module.exports = {
  byCityName: ({ lang, units }, { name, countryCode }) => {
    const location = [name];
    if (countryCode && countryCode.trim()) {
      location.push(countryCode.trim());
    }

    return get(CURRENT_FORECAST_URL, {
      q: location.join(),
      units,
      lang
    });
  },
  byCityID: ({ lang, units }, { id }) =>
    get(CURRENT_FORECAST_URL, {
      id,
      units,
      lang
    }),
  byLatLon: ({ lang, units }, { lat, lon }) =>
    get(CURRENT_FORECAST_URL, {
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

    return get(CURRENT_FORECAST_URL, {
      zip: location.join(),
      units,
      lang
    });
  }
};
