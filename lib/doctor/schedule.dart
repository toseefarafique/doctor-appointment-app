import 'package:flutter/material.dart';
import 'time_slots.dart';

class Schedule extends StatelessWidget {
  const Schedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Schedule"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Schedule",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20,),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text("Monday"),
                subtitle: const Text("10:00AM-2:00PM"),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text("Friday"),
                subtitle: const Text("2:00:00PM-6:00PM"),
              ),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context)=>const TimeSlots()
                ),
                );

              },
              child: const Text("Manage Time Slots"),
            ),
          


          ],

        )
      )
    );
  }
}          