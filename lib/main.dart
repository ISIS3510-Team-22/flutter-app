import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studyglide/constants/constants.dart';
import 'package:studyglide/models/offline_messages_model.dart';
import 'package:studyglide/models/offline_profile_update_model.dart';
import 'package:studyglide/services/connect_alert_service.dart';
import 'package:studyglide/services/connectivity_service.dart';
import 'routes.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'services/connectivity_service.dart';

// ConnectivityService connectivityService = ConnectivityService();
ConnectivityService connectivityService = ConnectivityService();

void configureFirestore() {
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true, // Habilita la persistencia offline
    cacheSizeBytes: Settings
        .CACHE_SIZE_UNLIMITED, // Ajusta el tamaño del caché si es necesario
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
  await Hive.initFlutter();
  Hive.registerAdapter(OfflineMessageAdapter());
  Hive.registerAdapter(OfflineProfileUpdateAdapter());
  await Hive.openBox('offline_messages');
  await Hive.openBox('offline_profile_updates');
  configureFirestore();
  ConnectionService().startMonitoring();
  runApp(StudyGlideApp());
}

class StudyGlideApp extends StatefulWidget {
  StudyGlideApp({super.key});
  // Create the FirebaseAnalytics instance
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  @override
  _StudyGlideAppState createState() => _StudyGlideAppState();
}

class _StudyGlideAppState extends State<StudyGlideApp> {
  late StreamSubscription<User?> authSubscription;

  @override
  void initState() {
    super.initState();
    authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("Usuario no autenticado");
      } else {
        print("Usuario autenticado: ${user.email}");
      }
    });
  }

  @override
  void dispose() {
    authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyGlide',
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: widget.analytics),
      ],
      theme: ThemeData(
        primaryColor: darkBlueColor,
        scaffoldBackgroundColor: darkBlueColor,
      ),
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/' : '/information',
      routes: appRoutes,
    );
  }
}
