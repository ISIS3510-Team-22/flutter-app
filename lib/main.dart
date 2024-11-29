import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studyglide/models/offline_messages_model.dart';
import 'package:studyglide/models/offline_profile_update_model.dart';
import 'constants/constants.dart';
import 'routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/connectivity_service.dart';

  ConnectivityService connectivityService = ConnectivityService();


void configureFirestore() {
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true, // Habilita la persistencia offline
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED, // Ajusta el tamaño del caché si es necesario
  );
}

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
  configureFirestore();

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
