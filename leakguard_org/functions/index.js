const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.database();

// Auto Shut-off if a leak is detected
exports.autoShutoff = functions.database.ref("/leak_detected")
    .onUpdate(async (change, context) => {
        const newValue = change.after.val();
        if (newValue === true) {
            console.log("Leak detected! Shutting off water...");
            await db.ref("/water_valve").set("off");

            // Send an alert
            await db.ref("/alerts").push({
                type: "Leak Detected",
                status: "Critical",
                time: new Date().toISOString(),
            });
        }
    });
