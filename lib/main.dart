import 'package:flutter/material.dart';
import 'constants/constants.dart';
import 'routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(StudyGlideApp());
}

class StudyGlideApp extends StatelessWidget {
  StudyGlideApp({super.key});
  // Create the FirebaseAnalytics instance
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Glide',
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],

      theme: ThemeData(
        primaryColor: darkBlueColor,
        scaffoldBackgroundColor: darkBlueColor,
      ),
      initialRoute: '/', // The initial route is the main view
      routes: appRoutes, // Use the defined routes
    );
  }
}
