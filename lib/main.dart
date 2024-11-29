import 'package:flutter/material.dart';
import 'package:studyglide/models/offline_messages_model.dart';
import 'package:studyglide/models/offline_profile_update_model.dart';
import 'package:studyglide/services/connectivity_alert_service.dart';
import 'constants/constants.dart';
import 'routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'services/connectivity_service.dart';

// ConnectivityService connectivityService = ConnectivityService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(OfflineMessageAdapter());
  Hive.registerAdapter(OfflineProfileUpdateAdapter());
  await Hive.openBox('offline_messages');
  await Hive.openBox('offline_profile_updates');
  // ConnectionService().startMonitoring();


  runApp(StudyGlideApp());
}

class StudyGlideApp extends StatelessWidget {
  StudyGlideApp({super.key});
  // Create the FirebaseAnalytics instance
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyGlide',
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
