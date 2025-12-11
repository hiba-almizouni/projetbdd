// src/api.js
const API_URL = "http://127.0.0.1:8000"; // your FastAPI backend URL

// 1. Most polluted zones
export async function getMostPollutedZones() {
  const res = await fetch(`${API_URL}/analytics/most_polluted_zones`);
  return res.json();
}

// 2. Sensor availability
export async function getSensorAvailability() {
  const res = await fetch(`${API_URL}/analytics/sensor_availability`);
  return res.json();
}

// 3. Top citizens
export async function getTopCitizens(limit = 10) {
  const res = await fetch(`${API_URL}/analytics/top_citizens?limit=${limit}`);
  return res.json();
}

// 4. Predictive interventions for current month
export async function getPredictiveInterventions() {
  const res = await fetch(`${API_URL}/analytics/predictive_interventions_month`);
  return res.json();
}

// 5. Top trips
export async function getTopTrips(limit = 10) {
  const res = await fetch(`${API_URL}/analytics/top_trips?limit=${limit}`);
  return res.json();
}

// 6. Air quality readings
export async function getAirQualityReadings(hours = 24) {
  const res = await fetch(`${API_URL}/sensors/air_quality_readings?hours=${hours}`);
  return res.json();
}

// 7. Test backend DB
export async function testBackendDB() {
  const res = await fetch(`${API_URL}/test-db`);
  return res.json();
}
