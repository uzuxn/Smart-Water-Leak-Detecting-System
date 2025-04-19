import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ManualControlScreen extends StatefulWidget {
  const ManualControlScreen({super.key});

  @override
  _ManualControlScreenState createState() => _ManualControlScreenState();
}

class _ManualControlScreenState extends State<ManualControlScreen> {
  bool isValveOpen = true; // Default open
  double leakSensitivity = 0.5;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _loadInitialValues();
  }

  void _loadInitialValues() async {
    final valveSnapshot = await _dbRef.child("control/main_valve_status").get();
    final sensitivitySnapshot =
        await _dbRef.child("control/leak_sensitivity").get();

    if (valveSnapshot.exists) {
      setState(() {
        isValveOpen = valveSnapshot.value.toString() == "open";
      });
    }

    if (sensitivitySnapshot.exists) {
      setState(() {
        leakSensitivity =
            double.tryParse(sensitivitySnapshot.value.toString()) ??
            leakSensitivity;
      });
    }
  }

  Future<void> _updateValveStatus() async {
    try {
      await _dbRef
          .child("control/main_valve_status")
          .set(isValveOpen ? "open" : "closed");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Valve status updated to ${isValveOpen ? "Open" : "Closed"}",
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update valve status: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateLeakSensitivity(double value) async {
    try {
      await _dbRef.child("control/leak_sensitivity").set(value);
    } catch (e) {
      print("Error updating sensitivity: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manual Control"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildValveStatusCard(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isValveOpen ? Colors.red : Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    isValveOpen = !isValveOpen;
                  });
                  _updateValveStatus();
                },
                child: Text(
                  isValveOpen ? "Close Valve" : "Open Valve",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLeakSensitivitySlider(),
          ],
        ),
      ),
    );
  }

  Widget _buildValveStatusCard() {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(
          isValveOpen ? Icons.water_drop : Icons.block,
          color: isValveOpen ? Colors.green : Colors.red,
          size: 30,
        ),
        title: const Text(
          "Valve Status",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          isValveOpen ? "Open" : "Closed",
          style: TextStyle(
            color: isValveOpen ? Colors.green : Colors.red,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildLeakSensitivitySlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Leak Detection Sensitivity",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Slider(
          value: leakSensitivity,
          min: 0.1,
          max: 1.0,
          divisions: 9,
          label: leakSensitivity.toStringAsFixed(1),
          onChanged: (value) {
            setState(() {
              leakSensitivity = value;
            });
            _updateLeakSensitivity(value);
          },
        ),
      ],
    );
  }
}
