import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/adapting_viewmodel';
import '../constants/constants.dart';

class AdaptingTipsView extends StatelessWidget {
  const AdaptingTipsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Accessing the RecipeViewModel
    return ChangeNotifierProvider(
      create: (context) => AdaptingViewModel()..fetchAdaptingTips(),
      child: Consumer<AdaptingViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: darkBlueColor,
              foregroundColor: Colors.white,
              title: const Text(
                'ADAPTING TO A NEW CITY',
                style: headerTextStyle,
              ),
            ),
            body: viewModel.adaptingTips.isNotEmpty
                ? ListView.builder(
                    itemCount: viewModel.adaptingTips.length,
                    itemBuilder: (context, index) {
                      final tip = viewModel.adaptingTips[index];
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
                              tip.title,
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
                                      tip.description,
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
