import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/universities_viewmodel.dart';
import '../viewmodels/searched_queries_viewmodel.dart';
import '../models/university_model.dart';
import './university_detail_view.dart';
import '../constants/constants.dart';

class UniversitiesView extends StatefulWidget {
  const UniversitiesView({super.key});

  @override
  State<UniversitiesView> createState() => _UniversitiesViewState();
}

class _UniversitiesViewState extends State<UniversitiesView> {
  String searchQuery = '';
  final TextEditingController _controller = TextEditingController();
  final SearchedQueriesViewModel searchedQueriesViewModel =
      SearchedQueriesViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UniversityViewModel()..fetchUniversities(),
      child: Consumer<UniversityViewModel>(
        builder: (context, viewModel, child) {
          List<University> filteredUniversities =
              viewModel.universities.where((university) {
            return university.name
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
          }).toList();

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
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              hintStyle: buttonTextStyle,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_alt_outlined,
                              color: Colors.white),
                          onPressed: () {
                            // Trigger the onChanged function only when the icon is tapped
                            searchedQueriesViewModel.addQuery(_controller.text);
                            setState(() {
                              searchQuery = _controller.text;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                      height: 20), // Spacing between the search bar and list

                  // List of Universities
                  Expanded(
                    child: viewModel.universities.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredUniversities.length,
                            itemBuilder: (context, index) {
                              final university = filteredUniversities[index];
                              return Padding(
                                padding: const EdgeInsets.all(
                                    8.0), // Add some padding around each item
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        grayBlueColor, // Darker blue for the university container
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      university.name,
                                      style: bodyTextStyle,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UniversityDetailView(
                                                  university: university),
                                        ),
                                      );
                                    },
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
