import 'package:flutter/material.dart';
import '../constants/constants.dart'; // Import color and style constants

class MainView extends StatelessWidget {
  MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exchange App'),
      ),
      body: const Text('Main View'),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: brightBlueColor,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/information');
              break;
            case 1:
              Navigator.pushNamed(context, '/information');
              break;
            case 2:
              Navigator.pushNamed(context, '/information');
              break;
            case 3:
              Navigator.pushNamed(context, '/');
              break;
          }
          ;
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
