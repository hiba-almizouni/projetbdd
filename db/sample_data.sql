INSERT INTO owners (name, address, phone, email, ownership_type) VALUES
('Neo-Sousse Municipality', 'City Hall, Neo-Sousse', '111-111-111', 'contact@neo-sousse.tn', 'municipality'),
('GreenTech Partners', 'Tech Park, Neo-Sousse', '222-222-222', 'info@greentech.tn', 'private');

INSERT INTO sensors (sensor_id, sensor_type, latitude, longitude, district, status, owner_id, installation_date) VALUES
(gen_random_uuid(), 'air_quality', 35.821000, 10.640000, 'Center', 'active', 1, '2025-01-10'),
(gen_random_uuid(), 'air_quality', 35.835000, 10.620000, 'North', 'active', 1, '2025-02-05'),
(gen_random_uuid(), 'traffic', 35.820500, 10.650000, 'Center', 'maintenance', 2, '2025-03-12'),
(gen_random_uuid(), 'energy', 35.810000, 10.630000, 'South', 'active', 2, '2025-04-01');

INSERT INTO technicians (full_name, certification_level, phone, email) VALUES
('Ali Ben Salah', 'Level 1', '500-000-001', 'ali@city.tn'),
('Sara Trabelsi', 'Level 2', '500-000-002', 'sara@city.tn'),
('Mohamed Ayari', 'Level 2', '500-000-003', 'mohamed@city.tn');

INSERT INTO interventions (sensor_id, intervention_datetime, intervention_type, duration_minutes, cost, co2_impact_kg, description)
SELECT sensor_id, '2025-05-10 09:00', 'predictive', 60, 150.00, 25.5, 'Predictive maintenance on air quality sensor'
FROM sensors WHERE sensor_type = 'air_quality' LIMIT 1;

INSERT INTO interventions (sensor_id, intervention_datetime, intervention_type, duration_minutes, cost, co2_impact_kg, description)
SELECT sensor_id, '2025-05-15 14:00', 'corrective', 90, 220.00, 10.0, 'Corrective maintenance on traffic sensor'
FROM sensors WHERE sensor_type = 'traffic' LIMIT 1;

-- Link technicians to interventions (ensure at least two)
INSERT INTO intervention_technicians (intervention_id, technician_id, role) VALUES
(1, 1, 'actor'),
(1, 2, 'validator'),
(2, 2, 'actor'),
(2, 3, 'validator');

INSERT INTO citizens (full_name, address, phone, email, eco_score, mobility_preferences) VALUES
('Nadia K', 'District Center 3', '510-100-100', 'nadia@example.com', 85, 'Prefers bike and tram'),
('Omar L', 'District North 1', '510-100-200', 'omar@example.com', 92, 'Uses electric car sharing'),
('Salma R', 'District South 2', '510-100-300', 'salma@example.com', 70, 'Bus and walking');

INSERT INTO citizen_consultations (citizen_id, topic, participation_date, participation_mode, feedback) VALUES
(1, 'Air quality improvement', '2025-04-10', 'online', 'Supports low-emission zones'),
(1, 'Bike lane expansion', '2025-05-01', 'in-person', 'Requests more bike parking'),
(2, 'Public transport redesign', '2025-03-15', 'online', 'Wants better night buses');

INSERT INTO vehicles (plate_number, vehicle_type, energy_type, in_service) VALUES
('NS-1001-AV', 'waste_collection', 'electric', TRUE),
('NS-2001-AV', 'public_transport', 'hydrogen', TRUE),
('NS-3001-AV', 'street_cleaning', 'electric', FALSE);

INSERT INTO trips (vehicle_id, origin, destination, start_time, end_time, co2_saved_kg) VALUES
(1, 'District South', 'Waste Processing Plant', '2025-05-09 08:00', '2025-05-09 09:00', 45.5),
(2, 'Station A', 'Station D', '2025-05-09 09:30', '2025-05-09 10:15', 60.0),
(1, 'District Center', 'District North', '2025-05-10 06:00', '2025-05-10 06:45', 30.0);

-- Example readings for last 24 hours
INSERT INTO sensor_readings (sensor_id, reading_time, metric, value, unit)
SELECT sensor_id, NOW() - INTERVAL '1 hour', 'PM2.5', 35.2, 'µg/m3'
FROM sensors WHERE sensor_type = 'air_quality' LIMIT 1;

INSERT INTO sensor_readings (sensor_id, reading_time, metric, value, unit)
SELECT sensor_id, NOW() - INTERVAL '3 hours', 'PM2.5', 60.8, 'µg/m3'
FROM sensors WHERE sensor_type = 'air_quality' LIMIT 1 OFFSET 1;

