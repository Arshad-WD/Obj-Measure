// import 'package:flutter/material.dart';
// import 'detection_chat_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'AI Image Detection',
//       theme: ThemeData(
//         scaffoldBackgroundColor: Colors.white,
//         fontFamily: 'Poppins', // Use a premium font if available
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Gradient with a Premium Feel
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xFF0F2027),
//                   Color(0xFF203A43),
//                   Color(0xFF2C5364)
//                 ],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//           ),

//           // Main Content
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment:
//                 CrossAxisAlignment.center, // Ensure full centering
//             children: [
//               const Spacer(flex: 2),

//               // Glowing App Icon
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white.withOpacity(0.15),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 15,
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.image_search_rounded,
//                   size: 100,
//                   color: Colors.white,
//                 ),
//               ),

//               const SizedBox(height: 25),

//               // Title & Description Centered
//               const Center(
//                 // ✅ Ensures full centering
//                 child: Text(
//                   'AI-Powered Image Detection',
//                   textAlign: TextAlign.center, // ✅ Centers text inside itself
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 40),
//                 child: Center(
//                   // ✅ Also centers the description text
//                   child: Text(
//                     'Effortlessly analyze and detect objects in images with cutting-edge AI technology.',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 16, color: Colors.white70),
//                   ),
//                 ),
//               ),

//               const Spacer(),

//               // Start Detection Button with Modern Design
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const DetectionChatScreen()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 45, vertical: 18),
//                   backgroundColor:
//                       Colors.amberAccent, // Gold accent for a premium look
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   elevation: 12,
//                   shadowColor: Colors.black.withOpacity(0.3),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(Icons.camera_alt, color: Colors.black),
//                     const SizedBox(width: 12),
//                     const Text(
//                       'Start Detection',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const Spacer(flex: 2),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:object_measure/home_screen.dart';
import 'package:object_measure/splash.dart';
import 'package:object_measure/Profilepage.dart';
import 'package:object_measure/measure.dart';

// import 'package:ledim/measure.dart';
// import 'package:ledim/profilepage.dart';
// import 'package:ledim/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ledim',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light, // Switch to dark mode
      home: const Splash(),
      routes: {
        '/dashboard': (context) => const HomePageWidget(),
        '/profile': (context) => Profilepage(),
        '/measure': (context) => Measure(),
      },
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_embed_unity/flutter_embed_unity.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ARMeasurementApp(),
//     );
//   }
// }

// class ARMeasurementApp extends StatefulWidget {
//   @override
//   State<ARMeasurementApp> createState() => _ARMeasurementAppState();
// }

// class _ARMeasurementAppState extends State<ARMeasurementApp> {
//   String _distanceMessage = "Distance will appear here";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('AR Measurement App'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: EmbedUnity(
//               onMessageFromUnity: (String message) {
//                 setState(() {
//                   _distanceMessage = message;
//                 });
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               _distanceMessage,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 18),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
