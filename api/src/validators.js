const validateVitals = (data) => {
    const errors = {};
    const { device_id, timestamp, thermal_value, battery_level, memory_usage } = data;

    if (!device_id) errors.device_id = "Required field missing";
    if (!timestamp) errors.timestamp = "Required field missing";

    if (thermal_value === undefined || thermal_value < 0 || thermal_value > 3) {
        errors.thermal_value = "Thermal value must be between 0 and 3";
    }

    if (battery_level === undefined || battery_level < 0 || battery_level > 100) {
        errors.battery_level = "Battery level must be between 0 and 100";
    }

    if (memory_usage === undefined || memory_usage < 0 || memory_usage > 100) {
        errors.memory_usage = "Memory usage must be between 0 and 100";
    }

    const logTime = new Date(timestamp);
    const now = new Date();
    if (logTime.getTime() > (now.getTime() + 10 * 60 * 1000)) {
        errors.timestamp = "Timestamp cannot be in the future (beyond 10min drift)";
    }

    return errors;
};

module.exports = { validateVitals };
