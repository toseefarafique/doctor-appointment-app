import 'package:flutter/material.dart';

class TimeSlots extends StatelessWidget {
  const TimeSlots({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Slots"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Avilable time slots",
              style: TextStyle(
                fontSize: 20,
                 fontWeight: FontWeight.bold,    ),
            ),
            const SizedBox(height: 20,),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: (){},
                   child: const Text("10:00AM")
               ),
               ElevatedButton(
                  onPressed: (){},
                   child: const Text("10:30AM")
               ),
               ElevatedButton(
                  onPressed: (){},
                   child: const Text("11:00AM")
               ),
               ElevatedButton(
                  onPressed: (){},
                   child: const Text("11:30AM")
               ),
               ElevatedButton(
                  onPressed: (){},
                   child: const Text("12:00PM")
               ),
               ElevatedButton(
                  onPressed: (){},
                   child: const Text("12:30PM")
               ),

              ],
            ),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed:(){},
              child: const Text("Add Time slot"))

          ],
        )
      )
    );
  }
}          