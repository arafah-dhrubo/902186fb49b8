const express = require('express');
const router = express.Router();
const { db } = require('./database');
const { validateVitals } = require('./validators');

// POST /api/vitals - Create a new vital log
router.post('/', (req, res) => {
    const errors = validateVitals(req.body);
    if (Object.keys(errors).length > 0) {
        return res.status(400).json(errors);
    }

    const { device_id, timestamp, thermal_value, battery_level, memory_usage } = req.body;
    const sql = `INSERT INTO vitals (device_id, timestamp, thermal_value, battery_level, memory_usage) VALUES (?, ?, ?, ?, ?)`;
    const params = [device_id, timestamp, thermal_value, battery_level, memory_usage];

    db.run(sql, params, function (err) {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.status(201).json({ id: this.lastID, ...req.body });
    });
});

// GET /api/vitals - Get latest 100 vital logs for a specific device
router.get('/', (req, res) => {
    const { device_id } = req.query;

    if (!device_id) {
        return res.json([]);
    }

    const sql = `SELECT * FROM vitals WHERE device_id = ? ORDER BY timestamp DESC LIMIT 100`;
    db.all(sql, [device_id], (err, rows) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json(rows);
    });
});

// GET /api/vitals/analytics - Get analytics using SQL aggregates (optimized)
router.get('/analytics', (req, res) => {
    const { device_id } = req.query;

    if (!device_id) {
        return res.json({
            avg_thermal: null,
            avg_battery: null,
            avg_memory: null,
            health_status: "No Data",
            battery_trend: "Stable",
            sample_size: 0
        });
    }

    // Use SQL aggregations for better performance
    const sql = `
    SELECT 
      AVG(thermal_value) as avg_thermal,
      AVG(battery_level) as avg_battery,
      AVG(memory_usage) as avg_memory,
      COUNT(*) as sample_size
    FROM (SELECT * FROM vitals WHERE device_id = ? ORDER BY timestamp DESC LIMIT 100)
  `;

    db.get(sql, [device_id], (err, stats) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }

        if (!stats || stats.sample_size === 0) {
            return res.json({
                avg_thermal: null,
                avg_battery: null,
                avg_memory: null,
                health_status: "No Data",
                battery_trend: "Stable",
                sample_size: 0
            });
        }

        // Calculate Health Status
        let healthStatus = "Healthy";
        if (stats.avg_thermal > 2.0 || stats.avg_memory > 85.0) healthStatus = "Stress Detected";
        if (stats.avg_thermal >= 3.0) healthStatus = "Critical Heat";

        // For Battery Trend, we still need to query the raw values
        const trendSql = `SELECT battery_level FROM vitals WHERE device_id = ? ORDER BY timestamp DESC LIMIT 100`;
        db.all(trendSql, [device_id], (err, rows) => {
            let batteryTrend = "Stable";
            if (!err && rows.length >= 10) {
                const batteryValues = rows.map(r => r.battery_level);
                const recentAvg = batteryValues.slice(0, 5).reduce((a, b) => a + b, 0) / 5;
                const olderAvg = batteryValues.slice(-5).reduce((a, b) => a + b, 0) / 5;
                if (recentAvg < olderAvg - 1) batteryTrend = "Draining";
                else if (recentAvg > olderAvg + 1) batteryTrend = "Charging";
            }

            res.json({
                avg_thermal: stats.avg_thermal !== null ? Number(stats.avg_thermal.toFixed(2)) : null,
                avg_battery: stats.avg_battery !== null ? Number(stats.avg_battery.toFixed(2)) : null,
                avg_memory: stats.avg_memory !== null ? Number(stats.avg_memory.toFixed(2)) : null,
                health_status: healthStatus,
                battery_trend: batteryTrend,
                sample_size: stats.sample_size
            });
        });
    });
});

module.exports = router;
