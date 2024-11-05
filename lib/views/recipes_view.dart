import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/recipe_viewmodel.dart';
import '../constants/constants.dart';

class RecipeListView extends StatelessWidget {
  const RecipeListView({super.key});

  @override
  Widget build(BuildContext context) {
    // Accessing the RecipeViewModel
    return ChangeNotifierProvider(
      create: (context) => RecipeViewModel()..fetchRecords(),
      child: Consumer<RecipeViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: darkBlueColor,
              foregroundColor: Colors.white,
              title: const Text(
                'RECIPES',
                style: headerTextStyle,
              ),
              centerTitle: true,
            ),
            body: viewModel.recipes.isNotEmpty
                ? ListView.builder(
                    itemCount: viewModel.recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = viewModel.recipes[index];
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
                              recipe.name,
                              style: bodyTextStyle,
                            ),
                            subtitle: Text(
                              recipe.description,
                              style: subBodyTextStyle,
                            ),
                            iconColor: Colors.white,
                            collapsedIconColor: Colors.white,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Ingredients:",
                                      style: simpleText,
                                    ),
                                    ...recipe.ingredients
                                        .map((ingredient) => Text(
                                              "- $ingredient",
                                              style: simpleText,
                                            )),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Instructions:",
                                      style: simpleText,
                                    ),
                                    Text(
                                      recipe.instructions,
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
