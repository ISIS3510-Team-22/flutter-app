import 'package:flutter/material.dart';
import 'package:studyglide/views/main_view.dart';
import 'package:studyglide/views/profile.dart';
//import 'views/main_view.dart';
import 'views/information_view.dart';
import 'views/chat_view.dart';
import 'views/news_view.dart';
import 'views/ai_helper_view.dart';
import 'views/recipes_view.dart';
import 'views/mental_health_view.dart';
import 'views/adapting_tips_view.dart';
import 'views/universities_view.dart';
import 'views/login_view.dart';
import 'views/exchanges_availables_view.dart';

// Define your app routes here
final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const LoginPage(),
  '/home': (context) => MainView(),
  '/information': (context) => InformationView(),
  '/chat': (context) => const ChatListScreen(),
  '/news': (context) => NewsView(),
  '/profile': (context) => const ProfileView(),
  '/ai_helper': (context) => const AiHelperView(),
  '/information/recipes': (context) => const RecipeListView(),
  '/information/mental_health': (context) => const MentalHealthView(),
  '/information/adapting_tips': (context) => const AdaptingTipsView(),
  '/information/universities_info': (context) => const UniversitiesView(),
  '/information/exchanges': (context) => const ExchangesView(),
};
