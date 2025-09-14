import 'dart:convert';
import 'package:cooksy/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResultsScreen extends StatefulWidget {
  final String ingredients;

  const ResultsScreen({super.key, required this.ingredients});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    final apiKey = AppConfig.spoonacularApiKey;
    final url =
        "https://api.spoonacular.com/recipes/findByIngredients?ingredients=${widget.ingredients}&number=10&apiKey=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            recipes = jsonDecode(response.body);
            isLoading = false;
          });
        }
      } else {
        throw Exception("Failed to load recipes");
      }
    } catch (e) {
      debugPrint("Error: $e");
      if (mounted) {
        setState(() {
        isLoading = false;
      });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Free proxy for dev. For prod, set up your own!
    const String corsProxy = "https://corsproxy.io/?";

    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipes"),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        elevation: 2,
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.orangeAccent,
              ),
            )
          : recipes.isEmpty
              ? const Center(
                  child: Text(
                    "No recipes found. Try different ingredients.",
                    style: TextStyle(fontSize: 16),
                  ),
                )

              : Column(
                children: [
                  // instructions
                  Container(
                    width: double.infinity,
                    color: Colors.orange.shade50,
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      "• Used ingredients: the items from your search that matched the recipe.\n"
                      "• Used ingredients: the items from your search that matched the recipe.",
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.2, vertical: 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = recipes[index];
                        final String imageUrl = recipe['image'] ?? "";
                                      
                        return Card(
                          elevation: 5,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            
                            children: [
                              // image
                              SizedBox(
                                width: double.infinity,
                                child: imageUrl.isNotEmpty
                                    ? Image.network(
                                        "$corsProxy${Uri.encodeComponent(imageUrl)}",
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                          Icons.broken_image,
                                          size: 400,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : const Icon(Icons.broken_image, size: 50),
                              ),
                        
                              // text
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFF3E0),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe['title'] ?? "No Title",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.restaurant_menu,
                                              size: 14, color: Colors.orange),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${recipe['usedIngredientCount']} used • ${recipe['missedIngredientCount']} missing",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        
                              //
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
