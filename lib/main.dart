import 'package:flutter/material.dart';
import 'constants/constants.dart';
import 'views/main_view.dart';
import 'routes.dart';

void main() {
  runApp(const StudyGlideApp());
}

class StudyGlideApp extends StatelessWidget {
  const StudyGlideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Glide',
      theme: ThemeData(
        primaryColor: darkBlueColor,
        scaffoldBackgroundColor: lightGrayColor,
      ),
      initialRoute: '/', // The initial route is the main view
      routes: appRoutes, // Use the defined routes
    );
  }
}
