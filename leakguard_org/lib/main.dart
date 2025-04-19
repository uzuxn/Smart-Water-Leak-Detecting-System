// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'screens/home_screen.dart';
// import 'screens/watermonit_screen.dart';
// import 'screens/alerts_screen.dart';
// import 'screens/manualctrl_screen.dart';
// import 'screens/emerge_screen.dart';
// import 'screens/user_screen.dart';
// import 'screens/mainlayout_screen.dart';
// import 'screens/login_screen.dart';
// import 'screens/register_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       title: 'Water Leak Detection',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       routerConfig: _router,
//     );
//   }
// }

// // Define GoRouter navigation with Authentication Handling
// final GoRouter _router = GoRouter(
//   initialLocation: '/',
//   redirect: (context, state) {
//     final user = FirebaseAuth.instance.currentUser;
//     final isLoggingIn =
//         state.fullPath == '/login' || state.fullPath == '/register';

//     if (user == null && !isLoggingIn) {
//       return '/login'; // Redirect to login if user is not authenticated
//     }
//     return null;
//   },
//   routes: [
//     GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
//     GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
//     ShellRoute(
//       builder: (context, state, child) => MainLayoutScreen(child: child),
//       routes: [
//         GoRoute(path: '/', builder: (context, state) => HomeScreen()),
//         GoRoute(
//           path: '/monitoring',
//           builder: (context, state) => WaterMonitoringScreen(),
//         ),
//         GoRoute(path: '/alerts', builder: (context, state) => AlertsScreen()),
//         GoRoute(
//           path: '/manual',
//           builder: (context, state) => ManualControlScreen(),
//         ),
//         GoRoute(
//           path: '/emergency',
//           builder: (context, state) => EmergencyScreen(),
//         ),
//         GoRoute(path: '/user', builder: (context, state) => UserScreen()),
//       ],
//     ),
//   ],
// );
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/home_screen.dart';
import 'screens/watermonit_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/manualctrl_screen.dart';
import 'screens/emerge_screen.dart';
import 'screens/user_screen.dart';
import 'screens/mainlayout_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Water Leak Detection',
          theme: ThemeData(primarySwatch: Colors.blue),
          routerConfig: _router(snapshot.data),
        );
      },
    );
  }
}

// Define GoRouter navigation with Authentication Handling
GoRouter _router(User? user) {
  return GoRouter(
    initialLocation: user == null ? '/login' : '/',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
      ShellRoute(
        builder: (context, state, child) => MainLayoutScreen(child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => HomeScreen()),
          GoRoute(
            path: '/monitoring',
            builder: (context, state) => WaterMonitoringScreen(),
          ),
          GoRoute(path: '/alerts', builder: (context, state) => AlertsScreen()),
          GoRoute(
            path: '/manual',
            builder: (context, state) => ManualControlScreen(),
          ),
          GoRoute(
            path: '/emergency',
            builder: (context, state) => EmergencyScreen(),
          ),
          GoRoute(path: '/user', builder: (context, state) => UserScreen()),
        ],
      ),
    ],
  );
}
