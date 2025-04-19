import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alerts & Notifications"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('alerts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No alerts found."));
          }

          var alerts =
              snapshot.data!.docs.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                return {
                  "type": data['type'] ?? 'Unknown Alert',
                  "status": data['status'] ?? 'Pending',
                  "time": data['time'] ?? 'Unknown Time',
                  "color": _getAlertColor(data['status']),
                };
              }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 3,
                child: ListTile(
                  leading: Icon(
                    Icons.warning,
                    color: alerts[index]['color'],
                    size: 30,
                  ),
                  title: Text(
                    alerts[index]['type'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(alerts[index]['time']),
                  trailing: Text(
                    alerts[index]['status'],
                    style: TextStyle(color: alerts[index]['color']),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Function to determine alert colors based on status
  Color _getAlertColor(String? status) {
    switch (status) {
      case "Critical":
        return Colors.red;
      case "Warning":
        return Colors.orange;
      case "Resolved":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
