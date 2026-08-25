import 'package:flutter/material.dart';
import 'appointment_details.dart';

class Appointments extends StatelessWidget {
  const Appointments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointments"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Today appointment",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          ),
          const SizedBox(height: 15),
          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Ali Khan"),
              subtitle: const Text(
                "10:00 AM \n status:Pending",),
              trailing:ElevatedButton(onPressed: () {}, 
              child:const Text("Accept"),),
            ),
          ),


          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Sara Khan"),
              subtitle: const Text(
                "11:30 AM \n status:Accepted",),
               trailing: ElevatedButton(onPressed: (){
                 Navigator.push(
                   context,
                    MaterialPageRoute(
                     builder: (context)
                         => const AppointmentDetails(),
                  ),
                 );  
              }, 
              child:const Text("View"),),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Eman Fatima"),
              subtitle: const Text(
                "2:00 PM \n status:Pending",),
              trailing:ElevatedButton(onPressed: () {}, 
              child:const Text("Accept"),),
            ),
          ),
        ],
      )  
    );
  }
}      