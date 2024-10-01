import 'package:flutter/material.dart';
import 'views/main_view.dart';
import 'views/information_view.dart';
// import 'views/chat.dart';
// import 'views/news.dart';
// import 'views/ai_helper.dart';

// Define your app routes here
final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => MainView(),
  '/information': (context) => InformationView(),
  // '/mental_health': (context) => MentalHealthView(),
  // '/universities_info': (context) => UniversitiesInfoView(),
  // '/current_exchanges': (context) => CurrentExchangesView(),
};
