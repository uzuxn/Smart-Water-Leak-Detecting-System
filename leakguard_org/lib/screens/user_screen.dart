import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isDarkMode = false; // Dark mode toggle
  User? _user;
  String _username = "User"; // Default username

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Fetch user details from Firestore
  Future<void> _getUserData() async {
    _user = _auth.currentUser;

    if (_user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        setState(() {
          _username = userDoc['username'] ?? "User";
        });
      }
    }
  }

  // Logout function
  Future<void> _logout() async {
    await _auth.signOut();
    if (mounted) {
      context.go('/login'); // Redirect to login screen after logout
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Profile"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            _buildProfileCard(),

            const SizedBox(height: 20),

            // Dark Mode Toggle
            _buildDarkModeToggle(),

            const SizedBox(height: 20),

            // Logout Button
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  // Profile Card Widget
  Widget _buildProfileCard() {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(
            'assets/user_avatar.png',
          ), // Placeholder image
        ),
        title: Text(
          _username, // Fetching from Firestore
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          _user?.email ?? "No email available",
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  // Dark Mode Toggle
  Widget _buildDarkModeToggle() {
    return Card(
      elevation: 4,
      child: SwitchListTile(
        title: const Text(
          "Dark Mode",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        value: isDarkMode,
        onChanged: (value) {
          setState(() {
            isDarkMode = value;
          });
        },
      ),
    );
  }

  // Logout Button
  Widget _buildLogoutButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        onPressed: _logout,
        child: const Text(
          "Logout",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
