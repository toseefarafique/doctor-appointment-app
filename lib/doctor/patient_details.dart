import 'package:flutter/material.dart';

class PatientDetails extends StatelessWidget {
  const PatientDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Details"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Patient Information",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            
            const SizedBox(height: 20,),
            const Text("Name:Sara khan",
            style: TextStyle(fontSize:18),
            ),
            const SizedBox(height: 15,),
            const Text("Age:28",
            style: TextStyle(fontSize:18),
            ),
           const SizedBox(height: 10,),
            const Text("Gender:Female",
            style: TextStyle(fontSize:18),
            ),
            const SizedBox(height: 10,),
            const Text("Phone:0300-1234567",
            style: TextStyle(fontSize:18),
            ),
           const SizedBox(height: 10,),
            const Text("Medical History:Diabetes",
            style: TextStyle(fontSize:18),
            ),
          
          
          
          ],
        ),
      )
    );    
  }
}  