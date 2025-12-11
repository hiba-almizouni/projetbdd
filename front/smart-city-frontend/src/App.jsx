import { useEffect, useState } from "react";
import axios from "axios";

const API_BASE = "http://localhost:8000";

function App() {
  const [mostPolluted, setMostPolluted] = useState([]);
  const [availability, setAvailability] = useState([]);
  const [topCitizens, setTopCitizens] = useState([]);
  const [predictive, setPredictive] = useState([]);
  const [topTrips, setTopTrips] = useState([]);
  const [airReadings, setAirReadings] = useState([]);

  useEffect(() => {
    axios.get(`${API_BASE}/analytics/most_polluted_zones`).then((res) => setMostPolluted(res.data));
    axios.get(`${API_BASE}/analytics/sensor_availability`).then((res) => setAvailability(res.data));
    axios.get(`${API_BASE}/analytics/top_citizens?limit=5`).then((res) => setTopCitizens(res.data));
    axios.get(`${API_BASE}/analytics/predictive_interventions_month`).then((res) => setPredictive(res.data));
    axios.get(`${API_BASE}/analytics/top_trips?limit=5`).then((res) => setTopTrips(res.data));
    axios.get(`${API_BASE}/sensors/air_quality_readings?hours=24`).then((res) => setAirReadings(res.data));
  }, []);

  return (
    <div className="bg-light min-vh-100">
      <nav className="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <div className="container">
          <span className="navbar-brand fw-bold">
            Smart City Analytics
          </span>
        </div>
      </nav>

      <div className="container pb-5">
        {/* KPI cards */}
        <div className="row g-3 mb-4">
          <div className="col-md-4">
            <div className="card shadow-sm h-100">
              <div className="card-body">
                <h5 className="card-title">Most Polluted Zone (24h)</h5>
                {mostPolluted.length > 0 ? (
                  <p className="card-text fs-5">
                    <span className="fw-semibold">{mostPolluted[0].district}</span> –{" "}
                    {mostPolluted[0].avg_pm25.toFixed(1)} µg/m³ PM2.5
                  </p>
                ) : (
                  <p className="text-muted mb-0">No data</p>
                )}
              </div>
            </div>
          </div>

          <div className="col-md-4">
            <div className="card shadow-sm h-100">
              <div className="card-body">
                <h5 className="card-title">Predictive Interventions (Month)</h5>
                {predictive.length > 0 ? (
                  <p className="card-text fs-5">
                    Count: <span className="fw-semibold">{predictive[0].predictive_count}</span>
                    <br />
                    CO₂ saved:{" "}
                    <span className="fw-semibold">
                      {predictive[0].total_co2_saved_kg ?? 0} kg
                    </span>
                  </p>
                ) : (
                  <p className="text-muted mb-0">No data</p>
                )}
              </div>
            </div>
          </div>

          <div className="col-md-4">
            <div className="card shadow-sm h-100">
              <div className="card-body">
                <h5 className="card-title">Top Trip CO₂ Savings</h5>
                {topTrips.length > 0 ? (
                  <p className="card-text fs-5">
                    <span className="fw-semibold">{topTrips[0].plate_number}</span> –{" "}
                    {topTrips[0].co2_saved_kg} kg
                  </p>
                ) : (
                  <p className="text-muted mb-0">No data</p>
                )}
              </div>
            </div>
          </div>
        </div>

        {/* Availability table */}
        <div className="card shadow-sm mb-4">
          <div className="card-body">
            <h4 className="card-title mb-3">Sensor Availability by District</h4>
            <table className="table table-striped table-hover mb-0">
              <thead className="table-dark">
                <tr>
                  <th>District</th>
                  <th>Availability rate</th>
                </tr>
              </thead>
              <tbody>
                {availability.map((a, idx) => (
                  <tr key={idx}>
                    <td>{a.district}</td>
                    <td>{(a.availability_rate * 100).toFixed(1)}%</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Top citizens */}
        <div className="row g-3 mb-4">
          <div className="col-lg-6">
            <div className="card shadow-sm h-100">
              <div className="card-body">
                <h4 className="card-title mb-3">Top Engaged Citizens</h4>
                <table className="table table-sm table-bordered mb-0">
                  <thead className="table-secondary">
                    <tr>
                      <th>Name</th>
                      <th>Eco score</th>
                      <th>Participation count</th>
                    </tr>
                  </thead>
                  <tbody>
                    {topCitizens.map((c) => (
                      <tr key={c.citizen_id}>
                        <td>{c.full_name}</td>
                        <td>{c.eco_score}</td>
                        <td>{c.participation_count}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          {/* Top trips */}
          <div className="col-lg-6">
            <div className="card shadow-sm h-100">
              <div className="card-body">
                <h4 className="card-title mb-3">Top CO₂-Saving Trips</h4>
                <table className="table table-sm table-bordered mb-0">
                  <thead className="table-secondary">
                    <tr>
                      <th>Vehicle</th>
                      <th>Origin</th>
                      <th>Destination</th>
                      <th>CO₂ saved (kg)</th>
                    </tr>
                  </thead>
                  <tbody>
                    {topTrips.map((t) => (
                      <tr key={t.trip_id}>
                        <td>{t.plate_number}</td>
                        <td>{t.origin}</td>
                        <td>{t.destination}</td>
                        <td>{t.co2_saved_kg}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

        {/* Simple text list of last readings (Bootstrap list group) */}
        <div className="card shadow-sm">
          <div className="card-body">
            <h4 className="card-title mb-3">
              Air Quality Readings (PM2.5 – last {""}
              <span className="fw-semibold">24h</span>)
            </h4>
            {airReadings.length === 0 ? (
              <p className="text-muted mb-0">No readings available.</p>
            ) : (
              <ul className="list-group list-group-flush">
                {airReadings.slice(0, 10).map((r, idx) => (
                  <li key={idx} className="list-group-item">
                    <span className="fw-semibold">{r.district}</span> –{" "}
                    {new Date(r.reading_time).toLocaleString()} :{" "}
                    <span className="badge text-bg-primary">{r.value} µg/m³</span>
                  </li>
                ))}
              </ul>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
