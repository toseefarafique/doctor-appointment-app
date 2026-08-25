import 'package:flutter/material.dart';
import 'patient_details.dart';
class AppointmentDetails extends StatelessWidget {
  const AppointmentDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointment Details"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 45,
                child: Icon(Icons.person,
                size: 45,),
              ),
            ),
            const SizedBox(height: 20,),
            const Text(
              "Patient information",style: TextStyle(
                fontSize: 22,     
                fontWeight: FontWeight.bold       ),
              
            ),
            const SizedBox(height: 20,),
            const Text(
              "Name:Sara khan",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10,),
            const Text("Age:25",
            style:TextStyle(fontSize:19),
            ),
            const Text(
              "Appointment Date: 25 August 2026",
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 10),

            const Text(
              "Appointment Time: 10:00 AM",
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 10),
            const Text(
              "Reason : Regular Checkup",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 25,),
            Row(children: [
              Expanded(child: ElevatedButton(onPressed: (){}, 
              child: const Text("Accept")),
              ),
               const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Reject"),
                  )
                ),  
            ],
            ),
            const SizedBox(height: 15,),

            ElevatedButton(onPressed: (){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context)=>const PatientDetails(),
              )
            );
            }, 
            child: const Text("View Patient Details"),)




          ],
       
        ) 
      )
    );
  }
}          