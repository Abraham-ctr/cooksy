import 'package:cooksy/screens/results_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  void _onSearch() {
    final ingredients = _controller.text.trim();

    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter at least one ingredient")),
      );
      return;
    }

    _controller.clear();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(ingredients: ingredients),
      ),
    );

    debugPrint("Searching recipes with: $ingredients");
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05, vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.only(left: 120),
              child: Image.asset("assets/cooksy_logo.png", fit: BoxFit.cover, height: deviceWidth * 0.17,)
            ),

            Text(
              "COOKSY",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50,
                color: Colors.orange,
                letterSpacing: 5,
              ),
            ),
            Text(
              "Find recipes. Save favorites. Cook smarter.",
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 60),

            Expanded(
              child: Center(
                child: Column(
                  children: [
                    // Ingredient Input
                    TextField(
                      controller: _controller,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Enter ingredients (e.g. tomato, cheese, pasta, rice)",
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.orangeAccent, width: 2)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.orangeAccent, width: 2)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2)
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Search Button
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: _onSearch,
                        child: Container(
                          width: deviceWidth,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(colors: [
                              Colors.deepOrangeAccent,
                              Colors.orange,
                              Colors.orangeAccent
                            ]),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orangeAccent.withOpacity(0.4),
                                offset: Offset(0, 5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Text(
                            "Find Recipes",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white70),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
