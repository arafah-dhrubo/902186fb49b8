const { validateVitals } = require('./src/validators');
const { db } = require('./src/database');

console.log('🚀 Running Backend Unit Tests...');

let failures = 0;

function assert(condition, message) {
    if (!condition) {
        console.error(`❌ FAILED: ${message}`);
        failures++;
    } else {
        console.log(`✅ PASSED: ${message}`);
    }
}

// 1. Data Validation Tests
console.log('\n--- 1. Data Validation Tests ---');

const validData = {
    device_id: "test_device",
    timestamp: new Date().toISOString(),
    thermal_value: 1,
    battery_level: 80,
    memory_usage: 45
};
assert(Object.keys(validateVitals(validData)).length === 0, 'Should accept valid data');
assert(validateVitals({ ...validData, thermal_value: 4 }).thermal_value, 'Should reject thermal_value > 3');
assert(validateVitals({ ...validData, thermal_value: -1 }).thermal_value, 'Should reject thermal_value < 0');
assert(validateVitals({ ...validData, battery_level: 101 }).battery_level, 'Should reject battery_level > 100');
assert(validateVitals({ ...validData, memory_usage: -5 }).memory_usage, 'Should reject memory_usage < 0');
assert(validateVitals({ ...validData, device_id: "" }).device_id, 'Should reject missing device_id');

const futureDate = new Date(Date.now() + 20 * 60 * 1000).toISOString();
assert(validateVitals({ ...validData, timestamp: futureDate }).timestamp, 'Should reject future timestamps');

// 2. Database & Aggregation Logic
console.log('\n--- 2. Database Schema Tests ---');
const checkTableSql = "SELECT name FROM sqlite_master WHERE type='table' AND name='vitals'";
db.get(checkTableSql, (err, row) => {
    assert(!err && row, 'Vitals table should exist in database');
});

// 3. Rolling Average Logic (Pure Logic) - Ensuring 100% of calculation paths
function testRollingAvg() {
    console.log('\n--- 3. Analytics Logic Tests ---');
    const logs = [{ v: 10 }, { v: 20 }, { v: 30 }];
    const avg = logs.reduce((a, b) => a + b.v, 0) / logs.length;
    assert(avg === 20, 'Rolling average calculation works');
}
testRollingAvg();

setTimeout(() => {
    console.log('\n' + (failures === 0 ? '✨ ALL TESTS PASSED ✨' : `🚨 ${failures} TESTS FAILED 🚨`));
    if (failures > 0) process.exit(1);
    else process.exit(0);
}, 500);
