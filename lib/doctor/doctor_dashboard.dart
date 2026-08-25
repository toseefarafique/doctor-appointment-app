import 'package:flutter/material.dart';
import 'doctor_profile.dart';
import 'appointment.dart';
import 'schedule.dart';


class DoctorDashboard extends StatelessWidget {
  const DoctorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Dashboard"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcom,Doctor!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text("Today's  appointments"),
                subtitle:
                 const Text("you have 5 appointments"),
                 onTap: () {
                  Navigator.push(context, 
                  MaterialPageRoute(builder:(context)=>const Appointments(),
                  ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.schedule),
                title: const Text("Manage Schedule"),
                subtitle:
                 const Text("Manage your avilable time slots"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder:(context)=>Schedule()),

                  );
                  
                }, 
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Doctor Profile"),
                subtitle: const Text("View and update your profile"),
                onTap: (){
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>const DoctorProfile()
                  ),

                );
                },
              ),
            ),
          ],
        ),
        )
        
        );
  }
}