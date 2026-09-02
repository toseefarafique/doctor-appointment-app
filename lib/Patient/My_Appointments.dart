import 'package:flutter/material.dart';
import 'Appointment_Details.dart';


class MyAppointments extends StatefulWidget {
  const MyAppointments({super.key});

  @override
  State<MyAppointments> createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
         icon: Icon(Icons.arrow_back,
         color: Colors.white,
         size: 30,)),
        title: Text("My Appointments",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedTab = 0;
                    });
                  },
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: selectedTab ==0 
                      ? Colors.blueAccent: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: BoxBorder.all(
                        color: Colors.blueAccent
                      )
                    ),
                    child: Center(
                      child: Text("Upcomming",
                      style: TextStyle(
                        color: selectedTab == 0
                        ?Colors.white: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                  ),
                )),
                SizedBox(width: 15),
                Expanded(child: GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedTab =1;
                    });
                  },
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: selectedTab ==1
                      ? Colors.blueAccent : Colors.white,
                     borderRadius:BorderRadius.circular(10),
                     border: BoxBorder.all(
                      color: Colors.blueAccent)
                    ),
                   child: Center(
                     child: Text("Past",
                    style: TextStyle(
                      color: selectedTab ==1
                      ? Colors.white : Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),),
                   ),
                  ),
                )),
              ],),
                SizedBox(height: 20),
                if(selectedTab == 0)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    )
                  ),
                  child: Row(
                    children: [
                       Container(
                     height: 90,
                      width: 90,
                    decoration: BoxDecoration(
                     color: const Color(0xFFE3EDFF),
                       borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset(
                      'assets/images/Doctor1.png',
                      fit: BoxFit.contain,
                        ),
                         ),
                  Padding(padding: EdgeInsets.only(left: 25),
                    child:Column(
                      children: [
                        Text("Dr.Ayesha Khan",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),),
                        SizedBox(height: 2),
                        Text("Cardiologist",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),),
                        SizedBox(height: 3),
                        Text("21-May-2024",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),),
                        SizedBox(height: 3),
                        Text("10:00 PM",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),),
                      ],
                    ) ), 
                      SizedBox(width: 15), 
                    Expanded(
                      child: Center(
                        child: ElevatedButton(onPressed: (){
                          Navigator.push(context,
                           MaterialPageRoute(builder: (context)=> const AppointmentDetails()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(10),
                          )
                        ),
                         child: Text("Upcomming",
                         style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                         ),))
                    )
                      ),
                    
                    
                      
                    ],
                  ),
                )
          else
           Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    )
                  ),
                  child: Row(
                    children: [
                       Container(
                     height: 90,
                      width: 90,
                    decoration: BoxDecoration(
                     color: const Color(0xFFE3EDFF),
                       borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset(
                      'assets/images/Doctor1.png',
                      fit: BoxFit.contain,
                        ),
                         ),
                  Padding(padding: EdgeInsets.only(left: 25),
                    child:Column(
                      children: [
                        Text("Dr.Ayesha Khan",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),),
                        SizedBox(height: 2),
                        Text("Cardiologist",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),),
                        SizedBox(height: 3),
                        Text("21-May-2024",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),),
                        SizedBox(height: 3),
                        Text("10:00 PM",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),),
                      ],
                    ) ), 
                   
                    Expanded(child: Center(
                      child: Text(
                     "Completed",
                  style: TextStyle(
                   color: Colors.grey,
                fontWeight: FontWeight.bold,
                ),
                ),
                    ))
                 
                        
                    
                    
                      
                    ],
                  ),
                )
          ],
        ),
      ),
    );
  }
}