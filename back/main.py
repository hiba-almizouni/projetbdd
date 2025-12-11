from fastapi import FastAPI
from typing import List, Any
from db import fetch_all
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="Smart City Analytics API")

origins = [
    "http://localhost:3000",  # frontend URL
    "http://127.0.0.1:3000"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
def health_check():
    return {"status": "ok"}

# 1. Most polluted zones (view)
@app.get("/analytics/most_polluted_zones")
def most_polluted_zones():
    rows = fetch_all("SELECT * FROM v_most_polluted_zones;")
    return rows

# 2. Sensor availability by district
@app.get("/analytics/sensor_availability")
def sensor_availability():
    rows = fetch_all("SELECT * FROM v_sensor_availability;")
    return rows

# 3. Top citizens engaged
@app.get("/analytics/top_citizens")
def top_citizens(limit: int = 10):
    rows = fetch_all(
        "SELECT * FROM v_top_citizens ORDER BY eco_score DESC, participation_count DESC LIMIT %s;",
        (limit,),
    )
    return rows

# 4. Predictive interventions summary for current month
@app.get("/analytics/predictive_interventions_month")
def predictive_interventions_month():
    rows = fetch_all("SELECT * FROM v_predictive_interventions_month;")
    return rows

# 5. Trips with greatest CO2 savings
@app.get("/analytics/top_trips")
def top_trips(limit: int = 10):
    rows = fetch_all(
        "SELECT * FROM v_top_trips_co2 LIMIT %s;",
        (limit,),
    )
    return rows

# 6. Recent air quality readings (for dashboard charts)
@app.get("/sensors/air_quality_readings")
def air_quality_readings(hours: int = 24):
    query = """
        SELECT s.district, sr.reading_time, sr.value
        FROM sensor_readings sr
        JOIN sensors s ON s.sensor_id = sr.sensor_id
        WHERE sr.metric = 'PM2.5' AND sr.reading_time >= NOW() - (%s || ' hours')::interval
        ORDER BY sr.reading_time;
    """
    rows = fetch_all(query, (hours,))
    return rows
from fastapi import FastAPI
from db import fetch_all  # make sure you have db.py



@app.get("/test-db")
def test_db():
    result = fetch_all("SELECT 1;")  # simple test query
    return {"db": result}

@app.get("/health")
def health_check():
    return {"status": "ok"}
