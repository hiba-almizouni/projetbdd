from datetime import datetime, timedelta
from db import fetch_all, execute

def generate_daily_air_quality_report():
    # Create report table if not exists
    execute("""
        CREATE TABLE IF NOT EXISTS daily_air_quality_report (
            report_date DATE PRIMARY KEY,
            worst_district VARCHAR(100),
            avg_pm25 NUMERIC(10,2)
        );
    """)

    yesterday = datetime.utcnow().date() - timedelta(days=1)

    rows = fetch_all("""
        SELECT s.district, AVG(sr.value) AS avg_pm25
        FROM sensor_readings sr
        JOIN sensors s ON s.sensor_id = sr.sensor_id
        WHERE sr.metric = 'PM2.5'
          AND sr.reading_time >= %s
          AND sr.reading_time < %s
        GROUP BY s.district
        ORDER BY avg_pm25 DESC
        LIMIT 1;
    """, (yesterday, yesterday + timedelta(days=1)))

    if rows:
        worst = rows[0]
        execute("""
            INSERT INTO daily_air_quality_report (report_date, worst_district, avg_pm25)
            VALUES (%s, %s, %s)
            ON CONFLICT (report_date) DO UPDATE
              SET worst_district = EXCLUDED.worst_district,
                  avg_pm25 = EXCLUDED.avg_pm25;
        """, (yesterday, worst["district"], worst["avg_pm25"]))

if __name__ == "__main__":
    generate_daily_air_quality_report()
