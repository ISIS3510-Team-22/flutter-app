import 'package:flutter/material.dart';
import 'views/main_view.dart';
import 'views/information_view.dart';
import 'views/chat_view.dart';
import 'views/news_view.dart';
import 'views/ai_helper_view.dart';
import 'views/recipes_view.dart';

// Define your app routes here
final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const MainView(),
  '/information': (context) => const InformationView(),
  '/chat': (context) => const ChatView(),
  '/news': (context) => const NewsView(),
  '/ai_helper': (context) => const AiHelperView(),
  '/recipes': (context) => const RecipeListView(),
};
