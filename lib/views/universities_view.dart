import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/universities_viewmodel.dart';
import '../constants/constants.dart';

class UniversitiesView extends StatelessWidget {
  const UniversitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UniversityViewModel()..fetchUniversities(),
      child: Consumer<UniversityViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: darkBlueColor, // Dark blue background
            appBar: AppBar(
              foregroundColor: Colors.white,
              backgroundColor: darkBlueColor,
              title: const Text(
                'UNIVERSITIES',
                style: headerTextStyle,
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar with Icon
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: grayColor, // Grey background for the search bar
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: buttonTextStyle,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Icon(Icons.filter_alt_outlined, color: Colors.white),
                      ],
                    ),
                  ),
                  const SizedBox(
                      height: 20), // Spacing between the search bar and list

                  // List of Universities
                  Expanded(
                    child: viewModel.universities.isNotEmpty
                        ? ListView.builder(
                            itemCount: viewModel.universities.length,
                            itemBuilder: (context, index) {
                              final university = viewModel.universities[index];
                              return Padding(
                                padding: const EdgeInsets.all(
                                    8.0), // Add some padding around each item
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        grayBlueColor, // Darker blue for the university container
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ExpansionTile(
                                    title: Text(
                                      university.name,
                                      style: bodyTextStyle,
                                    ),
                                    iconColor: Colors.white,
                                    collapsedIconColor: Colors.white,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "City:",
                                              style: simpleText,
                                              textAlign: TextAlign.start,
                                            ),
                                            Text(
                                              university.city,
                                              style: simpleText,
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              "Country:",
                                              style: simpleText,
                                            ),
                                            Text(
                                              university.country,
                                              style: simpleText,
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              "Students:",
                                              style: simpleText,
                                            ),
                                            Text(
                                              university.students.toString(),
                                              style: simpleText,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.wifi_off,
                                  size: 64.0,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  'No Internet Connection',
                                  style: simpleText,
                                ),
                              ],
                            ),
                          ), // Display if no data
                  ),

                  // "Ranking" button at the bottom
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              grayBlueColor, // Same color as the university container
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            'Ranking',
                            style: buttonTextStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
