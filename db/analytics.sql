-- Zones most polluted in last 24 hours (using PM2.5 as example)
CREATE OR REPLACE VIEW v_most_polluted_zones AS
SELECT
    s.district,
    AVG(sr.value) AS avg_pm25
FROM sensor_readings sr
JOIN sensors s ON s.sensor_id = sr.sensor_id
WHERE sr.metric = 'PM2.5'
  AND sr.reading_time >= NOW() - INTERVAL '24 hours'
GROUP BY s.district
ORDER BY avg_pm25 DESC;

-- Sensor availability rate by district
CREATE OR REPLACE VIEW v_sensor_availability AS
SELECT
    district,
    COUNT(*) FILTER (WHERE status = 'active')::DECIMAL
        / NULLIF(COUNT(*), 0) AS availability_rate
FROM sensors
GROUP BY district;

-- Most engaged citizens (by eco score and participation count)
CREATE OR REPLACE VIEW v_top_citizens AS
SELECT
    c.citizen_id,
    c.full_name,
    c.eco_score,
    COUNT(cc.consultation_id) AS participation_count
FROM citizens c
LEFT JOIN citizen_consultations cc ON c.citizen_id = cc.citizen_id
GROUP BY c.citizen_id, c.full_name, c.eco_score
ORDER BY c.eco_score DESC, participation_count DESC;

-- Count of predictive interventions this month and total CO2 savings
CREATE OR REPLACE VIEW v_predictive_interventions_month AS
SELECT
    DATE_TRUNC('month', intervention_datetime) AS month,
    COUNT(*) AS predictive_count,
    SUM(co2_impact_kg) AS total_co2_saved_kg
FROM interventions
WHERE intervention_type = 'predictive'
  AND DATE_TRUNC('month', intervention_datetime) = DATE_TRUNC('month', CURRENT_DATE)
GROUP BY DATE_TRUNC('month', intervention_datetime);

-- Trips with highest CO2 savings
CREATE OR REPLACE VIEW v_top_trips_co2 AS
SELECT
    t.trip_id,
    v.plate_number,
    t.origin,
    t.destination,
    t.co2_saved_kg
FROM trips t
JOIN vehicles v ON v.vehicle_id = t.vehicle_id
ORDER BY t.co2_saved_kg DESC;
