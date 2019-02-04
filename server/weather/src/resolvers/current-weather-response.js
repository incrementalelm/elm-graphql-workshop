const { get } = require('../utils');

const CURRENT_WEATHER_URL = 'https://api.openweathermap.org/data/2.5/weather';

module.exports = {
  temp: parent => parent.main.temp,
  tempMin: parent => parent.main.temp_min,
  tempMax: parent => parent.main.temp_max,
  pressure: parent => parent.main.pressure,
  humidity: parent => parent.main.humidity,
  sunrise: parent => parent.sys.sunrise,
  sunset: parent => parent.sys.sunset
};
