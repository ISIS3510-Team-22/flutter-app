import 'package:flutter/material.dart';
import '../constants/constants.dart'; // Import color and style constants

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Glide', style: titleTextStyle),
        backgroundColor: brightBlueColor,
      ),
      body: const Text('MAIN VIEW (LOGIN)', style: headerTextStyle),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        showUnselectedLabels: true,
        unselectedItemColor: darkBlueColor,
        selectedItemColor: darkBlueColor,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/information');
              break;
            case 1:
              Navigator.pushNamed(context, '/chat');
              break;
            case 2:
              Navigator.pushNamed(context, '/news');
              break;
            case 3:
              Navigator.pushNamed(context, '/ai_helper');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Information',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: 'AI Helper',
          ),
        ],
      ),
    );
  }
}
