-- Owners of sensors (municipality or private partners)
CREATE TABLE owners (
    owner_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    phone VARCHAR(50),
    email VARCHAR(255),
    ownership_type VARCHAR(50) NOT NULL CHECK (ownership_type IN ('municipality', 'private'))
);

-- Sensors
CREATE TABLE sensors (
    sensor_id UUID PRIMARY KEY,
    sensor_type VARCHAR(50) NOT NULL CHECK (sensor_type IN ('air_quality', 'traffic', 'energy', 'waste', 'lighting')),
    latitude NUMERIC(9,6) NOT NULL,
    longitude NUMERIC(9,6) NOT NULL,
    district VARCHAR(100),
    status VARCHAR(50) NOT NULL CHECK (status IN ('active', 'maintenance', 'out_of_service')),
    owner_id INTEGER NOT NULL REFERENCES owners(owner_id),
    installation_date DATE NOT NULL
);

-- Technicians
CREATE TABLE technicians (
    technician_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    certification_level VARCHAR(100),
    phone VARCHAR(50),
    email VARCHAR(255)
);

-- Interventions on sensors
CREATE TABLE interventions (
    intervention_id SERIAL PRIMARY KEY,
    sensor_id UUID NOT NULL REFERENCES sensors(sensor_id),
    intervention_datetime TIMESTAMP NOT NULL,
    intervention_type VARCHAR(50) NOT NULL CHECK (intervention_type IN ('predictive', 'corrective', 'curative')),
    duration_minutes INTEGER NOT NULL CHECK (duration_minutes >= 0),
    cost NUMERIC(12,2) NOT NULL CHECK (cost >= 0),
    co2_impact_kg NUMERIC(10,2),
    description TEXT
);

-- Link table: at least two technicians per intervention
CREATE TABLE intervention_technicians (
    intervention_id INTEGER NOT NULL REFERENCES interventions(intervention_id) ON DELETE CASCADE,
    technician_id INTEGER NOT NULL REFERENCES technicians(technician_id),
    role VARCHAR(50) NOT NULL CHECK (role IN ('actor', 'validator')),
    PRIMARY KEY (intervention_id, technician_id)
);

-- Citizens
CREATE TABLE citizens (
    citizen_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    address TEXT,
    phone VARCHAR(50),
    email VARCHAR(255),
    eco_score INTEGER NOT NULL CHECK (eco_score >= 0),
    mobility_preferences TEXT
);

-- Consultations participation history
CREATE TABLE citizen_consultations (
    consultation_id SERIAL PRIMARY KEY,
    citizen_id INTEGER NOT NULL REFERENCES citizens(citizen_id),
    topic VARCHAR(255) NOT NULL,
    participation_date DATE NOT NULL,
    participation_mode VARCHAR(50),
    feedback TEXT
);

-- Autonomous vehicles
CREATE TABLE vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    plate_number VARCHAR(20) UNIQUE NOT NULL,
    vehicle_type VARCHAR(50) NOT NULL,
    energy_type VARCHAR(50) NOT NULL,
    in_service BOOLEAN NOT NULL DEFAULT TRUE
);

-- Trips made by vehicles
CREATE TABLE trips (
    trip_id SERIAL PRIMARY KEY,
    vehicle_id INTEGER NOT NULL REFERENCES vehicles(vehicle_id),
    origin VARCHAR(255) NOT NULL,
    destination VARCHAR(255) NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    duration_minutes INTEGER GENERATED ALWAYS AS (EXTRACT(EPOCH FROM (end_time - start_time)) / 60)::INTEGER STORED,
    co2_saved_kg NUMERIC(10,2) NOT NULL CHECK (co2_saved_kg >= 0)
);

-- Time-series sensor data
CREATE TABLE sensor_readings (
    reading_id BIGSERIAL PRIMARY KEY,
    sensor_id UUID NOT NULL REFERENCES sensors(sensor_id),
    reading_time TIMESTAMP NOT NULL,
    metric VARCHAR(100) NOT NULL,
    value NUMERIC(14,4) NOT NULL,
    unit VARCHAR(50) NOT NULL
);

-- Indexes for performance
CREATE INDEX idx_sensor_readings_sensor_time ON sensor_readings(sensor_id, reading_time);
CREATE INDEX idx_sensors_district ON sensors(district);
CREATE INDEX idx_interventions_type_date ON interventions(intervention_type, intervention_datetime);
CREATE INDEX idx_trips_co2 ON trips(co2_saved_kg DESC);
