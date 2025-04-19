import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child(
    "water_system",
  );

  double waterLevel = 0.0;
  double flowRate = 0.0;
  double temperature = 0.0;
  double waterPressure = 0.0;
  bool leakDetected = false;

  @override
  void initState() {
    super.initState();

    // Fetch water level
    _database.child("water_level").onValue.listen((event) {
      setState(() {
        waterLevel = (event.snapshot.value as num).toDouble();
      });
    });

    // Fetch flow rate
    _database.child("flow_rate").onValue.listen((event) {
      setState(() {
        flowRate = (event.snapshot.value as num).toDouble();
      });
    });

    // Fetch temperature
    _database.child("water_temperature").onValue.listen((event) {
      setState(() {
        temperature = (event.snapshot.value as num).toDouble();
      });
    });

    // Fetch water pressure
    _database.child("water_pressure").onValue.listen((event) {
      setState(() {
        waterPressure = (event.snapshot.value as num).toDouble();
      });
    });

    // Fetch leak status
    _database.child("leak_status").onValue.listen((event) {
      setState(() {
        leakDetected = event.snapshot.value == "leak_detected";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LeakGuard Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLeakAlert(leakDetected),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildWaterLevelCard(waterLevel)),
                const SizedBox(width: 16),
                Expanded(child: _buildFlowRateCard(flowRate)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTemperatureCard(temperature)),
                const SizedBox(width: 16),
                Expanded(child: _buildWaterPressureCard(waterPressure)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Leak Alert Widget
  Widget _buildLeakAlert(bool leakDetected) {
    return Visibility(
      visible: leakDetected,
      child: Card(
        color: Colors.red.shade100,
        elevation: 4,
        child: ListTile(
          leading: const Icon(Icons.warning, color: Colors.red, size: 30),
          title: const Text(
            "Leak Detected!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text("Water supply will be shut off automatically."),
        ),
      ),
    );
  }

  /// Water Level Widget
  Widget _buildWaterLevelCard(double waterLevel) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Water Level",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: waterLevel / 100, minHeight: 10),
            const SizedBox(height: 8),
            Text(
              "${waterLevel.toStringAsFixed(1)}L / 100L",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// Flow Rate Widget
  Widget _buildFlowRateCard(double flowRate) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Flow Rate",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "${flowRate.toStringAsFixed(1)} L/min",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              flowRate > 10 ? "High Flow" : "Normal Flow",
              style: TextStyle(
                color: flowRate > 10 ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Temperature Widget
  Widget _buildTemperatureCard(double temperature) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Temperature",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "${temperature.toStringAsFixed(1)}°C",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              temperature > 50 ? "High Temperature" : "Normal",
              style: TextStyle(
                color: temperature > 50 ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Water Pressure Widget
  Widget _buildWaterPressureCard(double pressure) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Water Pressure",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "${pressure.toStringAsFixed(1)} PSI",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              pressure > 80 ? "High Pressure" : "Normal",
              style: TextStyle(
                color: pressure > 80 ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
