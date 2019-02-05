const { get } = require('../utils');
const CURRENT_FORECAST_URL = `https://api.openweathermap.org/data/2.5/forecast`;

module.exports = {
  byCityName: ({ lang }, { name, countryCode }) => {
    const location = [name];
    if (countryCode && countryCode.trim()) {
      location.push(countryCode.trim());
    }

    return get(CURRENT_FORECAST_URL, {
      q: location.join(),
      lang
    });
  },
  byCityID: ({ lang }, { id }) =>
    get(CURRENT_FORECAST_URL, {
      id,
      lang
    }),
  byLatLon: ({ lang }, { lat, lon }) =>
    get(CURRENT_FORECAST_URL, {
      lat,
      lon,
      lang
    }),
  byZIP: ({ lang }, { zip, countryCode }) => {
    const location = [zip];
    if (countryCode && countryCode.trim()) {
      location.push(countryCode.trim());
    }

    return get(CURRENT_FORECAST_URL, {
      zip: location.join(),
      lang
    });
  }
};
