import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import 'package:studyglide/widgets/customAppBar.dart';
import '../viewmodels/info_mostused_viewmodel.dart';

class InformationView extends StatelessWidget {
  InformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => InfoMostUsedViewModel()..getMostUsed(),
      child:
          Consumer<InfoMostUsedViewModel>(builder: (context, viewModel, child) {
        return Scaffold(
          appBar: const CustomAppBar(
            title: 'INFORMATION',
            actions: [
              IconButton(
                icon: Icon(Icons.calendar_today),
                color: Colors.white,
                onPressed: null,
              ),
            ],
          ),
          body: Container(
            color: darkBlueColor,
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: _getSortedInformationTiles(viewModel, context),
            ),
          ),
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
      }),
    );
  }
}

List<Widget> _getSortedInformationTiles(viewModel, context) {
  // Define the list of tiles with their associated usage counts
  final InfoMostUsedViewModel infoMostUsedViewModel = InfoMostUsedViewModel();

  List<Map<String, dynamic>> tiles = [
    {
      'title': 'Cooking & recipes while abroad',
      'count': viewModel.infoMostUseds.recipes,
      'onTap': () {
        infoMostUsedViewModel.updateField("recipes");
        Navigator.pushNamed(context, '/information/recipes');
      },
    },
    {
      'title': 'Mental Health',
      'count': viewModel.infoMostUseds.mental,
      'onTap': () {
        infoMostUsedViewModel.updateField("mental");
        Navigator.pushNamed(context, '/information/mental_health');
      },
    },
    {
      'title': 'Adapting to a new city',
      'count': viewModel.infoMostUseds.adapting,
      'onTap': () {
        infoMostUsedViewModel.updateField("adapting");
        Navigator.pushNamed(context, '/information/adapting_tips');
      },
    },
    {
      'title': 'Universities info',
      'count': viewModel.infoMostUseds.universities,
      'onTap': () {
        infoMostUsedViewModel.updateField("universities");
        Navigator.pushNamed(context, '/information/universities_info');
      },
    },
    {
      'title': 'Current exchanges available',
      'count': viewModel.infoMostUseds.exchanges,
      'onTap': () {
        infoMostUsedViewModel.updateField("exchanges");
        Navigator.pushNamed(context, '/information/exchanges');
      },
    },
  ];

  // Sort tiles by count in descending order
  tiles.sort((a, b) => b['count'].compareTo(a['count']));

  // Convert sorted list into a list of InformationTile widgets
  return tiles.map((tile) {
    return InformationTile(
      title: tile['title'],
      onTap: tile['onTap'],
    );
  }).toList();
}

class InformationTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap; // Add a callback for handling taps

  const InformationTile({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: onTap, // Call the onTap function when tapped
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: grayBlueColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: buttonTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}
