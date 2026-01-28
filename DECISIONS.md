# Handling Ambiguity & Design Decisions 

## Ambiguity 1: Analytics Endpoint Response Format
**Question**: What specific analytics should be returned beyond rolling average?
**Options Considered**:
- Option A: Only rolling average (simple, meets literal requirement).
- Option B: Broad metrics including Min, Max, and Sample Size (more comprehensive).
- Option C: Heuristic health status (Stress Detected, Healthy, etc.).
**Decision**: I chose Option B and C combined. Providing Min/Max alongside the average gives a better picture of spikes, and a simple health status string makes the data immediately actionable for the user.
**Trade-offs**: Slightly larger JSON payload, but significantly more useful for a monitor app.
**Assumptions**: Users want to know not just the average, but also if there have been dangerous spikes in thermal state.

## Ambiguity 2: Sensor Failure Handling
**Question**: What happens when a native sensor temporarily fails or is unavailable (e.g., on a simulator)?
**Options Considered**:
- Option A: Throw a PlatformException and stop the app functionality.
- Option B: Use -1 as a sentinel value and handle it in the UI.
- Option C: Return a cached last-known value.
**Decision**: I chose Option B. Using a sentinel value allows the UI to stay responsive and display a meaningful "N/A" state instead of crashing or showing stale data.
**Trade-offs**: Requires explicit checks in the UI layer.
**Assumptions**: A "N/A" display is better than a crash or a flat 0% which would be misleading.

## Ambiguity 3: Logging Frequency and Manual vs. Auto
**Question**: Can the user log data manually, or should it be automated?
**Options Considered**:
- Option A: Manual "Log Status" button only.
- Option B: Silent background logging every X minutes.
- Option C: Higher frequency logging (e.g., every 5 seconds).
**Decision**: I implemented Option A (Manual) as the primary requirement, but included a 5-second auto-refresh for the UI to satisfy "real-time" needs. Manual logging ensures we don't spam the server without user intent.
**Trade-offs**: Manual logging might lead to gaps in history if the user forgets.
**Assumptions**: For an initial submission, manual control with real-time UI monitoring is the safest baseline.

## Ambiguity 4: Database Selection for Persistence
**Question**: Which storage mechanism to use for the Node.js backend?
**Options Considered**:
- Option A: SQLite (Full SQL capabilities, single file).
- Option B: JSON file with locking (Simple, but brittle for concurrent writes).
- Option C: In-memory with periodic disk dump.
**Decision**: I chose Option A (SQLite). It satisfies the persistence requirement, handles concurrent writes safely via the database engine, and is self-contained without needing a separate server (like PostgreSQL).
**Trade-offs**: Requires a native dependency (`sqlite3`) which can sometimes be finicky during installation.
**Assumptions**: Reliability and data integrity are higher priorities than avoiding a DB dependency.

## Ambiguity 5: 
**Question**: Should the history screen show data for all devices collectively, or should it be filtered per `device_id` by default?
**Options Considered**:
- Option A: Show data for all devices collectively.
- Option B: Filter data per `device_id` by default.
- Option C: Show data for all devices collectively, but allow filtering per `device_id`.
**Decision**: I chose Option B (Filter data per `device_id` by default). 
**Trade-offs**: Requires complex logic to handle data inserting, fetching and display.
**Assumptions**: Data should be filtered per `device_id` by default. We are testing a single device. But if we need to test across multiple devices, the data should show based on the selected device.

## Ambiguity 6: Device Identification Handling
**Question**: How to handle `device_id` in the app for tracking telemetry?
**Options Considered**:
- Option A: Fetch the unique identifier from the native platform (e.g., `identifierForVendor` on iOS).
- Option B: Generate a persistent UUID on the first launch and store it in local storage.
- Option C: Use a hardcoded test ID for the duration of the MVP.
**Decision**: I chose Option A. Leveraging the native platform's unique identifier ensures that the `device_id` is stable across app restarts and unique to the device/vendor, providing the most reliable tracking for a monitor application without requiring user setup.
**Trade-offs**: Requires implementing Platform Channels to bridge native APIs to Flutter.
**Assumptions**: The backend can handle these platform-specific unique identifiers, and the native identifier is accessible in the current execution environment (falling back to a generic ID if null).

## Questions I Would Ask if PM were available:
1. What is the expected behavior if the device has intermittent connectivity? Should we implement a local "Store-and-Forward" mechanism (e.g., using Hive or SQLite) to prevent gaps in telemetry data during signal loss? 
2. What happens if the history log has more than 100 entries? Should we truncate, as those are unused?
3. Should the analytics rolling window be configurable (e.g., last hour vs. last 24 hours)?

