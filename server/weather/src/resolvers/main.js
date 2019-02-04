module.exports = {
  seaLevelPressure: parent => parent.sea_level,
  groundLevelPressure: parent => parent.grnd_level,
  tempMin: parent => parent.temp_min,
  tempMax: parent => parent.temp_max,
  tempKf: parent => parent.temp_kf
}
