import 'package:flutter/material.dart';

class Search_screen extends StatefulWidget {
  const Search_screen({super.key});

  @override
  State<Search_screen> createState() => _Search_screenState();
}

class _Search_screenState extends State<Search_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),

          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,

              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              title: const Text(
                "Search",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),

            body: SingleChildScrollView(
              child: Card(
                margin: const EdgeInsets.all(15),

                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [
                      // Search content will go here
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
