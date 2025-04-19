import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Get water level
  Future<double> getWaterLevel() async {
    try {
      DataSnapshot snapshot = await _database.child('water_level').get();
      if (snapshot.value != null) {
        return (snapshot.value as num).toDouble();
      }
    } catch (e) {
      print("Error fetching water level: $e");
    }
    return 0.0;
  }

  // Get flow rate
  Future<double> getFlowRate() async {
    try {
      DataSnapshot snapshot = await _database.child('flow_rate').get();
      if (snapshot.value != null) {
        return (snapshot.value as num).toDouble();
      }
    } catch (e) {
      print("Error fetching flow rate: $e");
    }
    return 0.0;
  }

  // Get temperature
  Future<double> getTemperature() async {
    try {
      DataSnapshot snapshot = await _database.child('temperature').get();
      if (snapshot.value != null) {
        return (snapshot.value as num).toDouble();
      }
    } catch (e) {
      print("Error fetching temperature: $e");
    }
    return 0.0;
  }

  // Get system health
  Future<int> getSystemHealth() async {
    try {
      DataSnapshot snapshot = await _database.child('system_health').get();
      if (snapshot.value != null) {
        return (snapshot.value as num).toInt();
      }
    } catch (e) {
      print("Error fetching system health: $e");
    }
    return 100; // Default value
  }

  // Get active alerts as a real-time stream
  Stream<List<String>> getActiveAlertsStream() {
    return _database.child('alerts').onValue.map((event) {
      final data = event.snapshot.value;
      if (data != null && data is List<dynamic>) {
        return data.map((e) => e.toString()).toList();
      }
      return [];
    });
  }
}
