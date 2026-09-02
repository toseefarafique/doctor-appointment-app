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
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
         icon: Icon(Icons.arrow_back,
         color: Colors.white,
         size: 30,)),
        title: Text("Search",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25
        ),),
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Padding(padding: EdgeInsets.all(20),
          child: Column(
            children: [
              
            ],
          ),),
          
        ),
      ),

    );
  }
}