import 'package:flutter/material.dart';
import 'views/main_view.dart';
import 'views/information_view.dart';
import 'views/chat_view.dart';
import 'views/news_view.dart';
import 'views/ai_helper_view.dart';

// Define your app routes here
final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => MainView(),
  '/information': (context) => InformationView(),
  '/chat': (context) => ChatView(),
  '/news': (context) => NewsView(),
  '/ai_helper': (context) => AiHelperView(),
};
