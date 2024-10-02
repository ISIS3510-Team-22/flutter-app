import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/mental_health_viewmodel.dart';
import '../constants/constants.dart';

class MentalHealthView extends StatelessWidget {
  const MentalHealthView({super.key});

  @override
  Widget build(BuildContext context) {
    // Accessing the RecipeViewModel
    return ChangeNotifierProvider(
      create: (context) => MentalHealthViewModel()..fetchRecords(),
      child: Consumer<MentalHealthViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: darkBlueColor,
              foregroundColor: Colors.white,
              title: const Text(
                'MENTAL HEALTH',
                style: headerTextStyle,
              ),
            ),
            body: viewModel.mentalHealthRecords.isNotEmpty
                ? ListView.builder(
                    itemCount: viewModel.mentalHealthRecords.length,
                    itemBuilder: (context, index) {
                      final mentalHealth = viewModel.mentalHealthRecords[index];
                      return Padding(
                        padding: const EdgeInsets.all(
                            8.0), // Add some padding around each item
                        child: Container(
                          decoration: BoxDecoration(
                            color: grayBlueColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ExpansionTile(
                            title: Text(
                              mentalHealth.title,
                              style: bodyTextStyle,
                            ),
                            iconColor: Colors.white,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 0),
                                    const Text(
                                      "Description:",
                                      style: simpleText,
                                    ),
                                    Text(
                                      mentalHealth.description,
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
                    child: Text('No data found')), // Display if no data
          );
        },
      ),
    );
  }
}
