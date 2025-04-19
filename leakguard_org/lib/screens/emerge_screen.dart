import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emergency"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plumber Contact Section
            _buildPlumberContact(),

            const SizedBox(height: 20),

            // Leak Prevention Tips Section
            _buildLeakPreventionTips(),
          ],
        ),
      ),
    );
  }

  // Plumber Contact Widget (Fetching from Firestore)
  Widget _buildPlumberContact() {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('emergency')
              .doc('plumber')
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        var data = snapshot.data!.data() as Map<String, dynamic>?;

        if (data == null || !data.containsKey('phone')) {
          return const Text("Plumber contact not available.");
        }

        String phoneNumber = data['phone'];

        return Card(
          elevation: 4,
          child: ListTile(
            leading: const Icon(Icons.phone, color: Colors.blue, size: 30),
            title: const Text(
              "Plumber Contact",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(phoneNumber),
            trailing: IconButton(
              icon: const Icon(Icons.call, color: Colors.green),
              onPressed: () => _makePhoneCall(phoneNumber),
            ),
          ),
        );
      },
    );
  }

  // Function to make a phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  // Leak Prevention Tips Widget (Fetching from Firestore)
  Widget _buildLeakPreventionTips() {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('emergency')
              .doc('tips')
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        var data = snapshot.data!.data() as Map<String, dynamic>?;

        if (data == null || !data.containsKey('tips')) {
          return const Text("No leak prevention tips available.");
        }

        List<dynamic> tips = data['tips'];

        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Leak Prevention Tips",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...tips.map((tip) => _buildTip(tip.toString())).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  // Reusable Tip Widget
  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
