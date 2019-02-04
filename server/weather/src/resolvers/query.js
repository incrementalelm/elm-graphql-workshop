const simpleResolve = (_, args) => args;

module.exports = {
  currentWeather: simpleResolve,
  fiveDayForecast: simpleResolve
};
